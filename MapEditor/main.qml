import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "qrc:///Tools"
import "qrc:///Scene"
import "qrc:///App"

import "qrc:///App/App.js" as App

Window {
	id: root
	visible: true
	width: 1024
	height: 768
	title: qsTr("MapEditor")

	QmlApp {
		id: app

		Component.onCompleted: {
			App.instance = app
		}
	}

	QtObject {
		id: mapProvider

		property var map

		function generateMap(width, height) {
			console.time("Server::generateMap")
			console.log("Server::generateMap::width:", width)
			console.log("Server::generateMap::height:", height)
			var result = []
			var layer = {
				"name": "Layer0"
				, "source": []
			}
			result.push(layer)

			for(var i = 0; i < width; ++i) {
				layer.source.push([])
				for(var j = 0; j < height; ++j) {
					var type = 0/*Math.round(Math.random() * (2))*/
					layer.source[i].push(type)
				}
			}

			layer = {
				"name": "Layer1"
				, "source": []
			}
			result.push(layer)

			for(var ii = 0; ii < width; ++ii) {
				layer.source.push([])
				for(var jj = 0; jj < height; ++jj) {
					type = -1/*Math.round(Math.random() * 1)*/
//					if(type === 1) {
//						type = 3
//					} else {
//						type = -1
//					}

					layer.source[ii].push(type)
				}
			}
			console.timeEnd("Server::generateMap")
			map = result
		}
	}

	ColumnLayout {
		id: controlsLayout

		RowLayout {
			Button {
				text: "generate"
				onClicked: {
					mapProvider.generateMap(10, 10)
					scene.loadMap(mapProvider.map)
				}
			}
			Button {
				text: "Export"
				onClicked: {
					var exportData = JSON.stringify(d.map)
					consoleArea.text = exportData
				}
			}
			Button {
				text: "Load"
				onClicked: {
					var loadData = JSON.parse(consoleArea.text)
					d.map = loadData
				}
			}
			Button {
				text: "Sync"
				onClicked: {
					d.map = d.map.concat()
				}
			}
		}

		RowLayout {
			ComboBox {
				function getBoxSource(app, index) {
					if(!app || !app.imageLibrary) {
						return ""
					}

					var value = boxTypeComboBox.model.get(index).value
					var result = app.imageLibrary.sourceAt(value)

					return result
				}

				id: boxTypeComboBox
				property QmlApp __app: App.instance
				property int boxType: currentIndex !== -1 && boxTypeComboBox.model.get(currentIndex).value || 0
				property string boxSource: getBoxSource(app, currentIndex)
				currentIndex: 0
				editable: false
				textRole: "key"
				model: ListModel {
					ListElement { key: "gray-stone"; value: 0; }
					ListElement { key: "grass"; value: 1 }
					ListElement { key: "brown-stone"; value: 2 }
					ListElement { key: "tree"; value: 3 }
				}
			}

			Image {
				source: boxTypeComboBox.boxSource
			}

			ComboBox {
				id: currentLayerComboBox
				textRole: "key"
				model: ListModel {
					ListElement { key: "Layer0"; value: 0; }
					ListElement { key: "Layer1"; value: 1 }
				}
			}
		}

		RowLayout {
			Item {
				id: viewport
				Scene {
					id: scene
					Layout.alignment: Qt.AlignTop
				}

				property var selectedLayerName
				property var selectedItem

				Rectangle {
					x: viewport.selectedItem && viewport.selectedItem.x || 0
					y: viewport.selectedItem && viewport.selectedItem.y || 0
					width: viewport.selectedItem && viewport.selectedItem.width || 0
					height: viewport.selectedItem && viewport.selectedItem.height || 0
					color: "transparent"
					border.color: "red"
					border.width: 1
				}

				Rectangle {
					width: 320
					height: 320
					color: "transparent"
					border {
						color: "red"
						width: 1
					}

					MouseArea {
						anchors.fill: parent
						acceptedButtons: Qt.LeftButton | Qt.RightButton

						onPressed: {
							var result = scene.hitTest(mouseX, mouseY)
							var ijObj = scene.xyToIj(mouseX, mouseY)
							if(result.item) {
								viewport.selectedItem = result.item
								viewport.selectedLayerName = result.layerName

								if(mouse.button == Qt.RightButton) {
									scene.remove(viewport.selectedLayerName, viewport.selectedItem)
									viewport.selectedLayerName = ""
									viewport.selectedItem = null
								} else {
//									viewport.selectedItem.type = boxTypeComboBox.boxType
									scene.addItem("Layer1", ijObj.i, ijObj.j, boxTypeComboBox.boxType)
								}
							} else {
								scene.addItem("Layer0", ijObj.i, ijObj.j, boxTypeComboBox.boxType)
							}
						}
//						onPositionChanged: {
//							var item = scene.hitTest(mouseX, mouseY)
//							if(item) {
//								item.type = boxesGroup.checkedButton.dataValue
//							}
//						}
					}
				}
			}

//			SelectTool {
//				id: selectTool
//				scene: scene

//			}
		}
	}
}

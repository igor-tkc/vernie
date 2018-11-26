import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3

import "qrc:///Tools"
import "qrc:///Scene"
import "qrc:///App"

import "qrc:///App/App.js" as App

// Designed by Igor

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

	FileDialog {
		id: exportFileDialog
		title: "Export file"
		folder: shortcuts.home
		selectExisting: false
		selectMultiple: false
		selectFolder: false
		nameFilters: [ "Map files (*.map)" ]

		onAccepted: {
			mapProvider.exportTo(exportFileDialog.fileUrl)
		}
	}

	FileDialog {
		id: importFileDialog
		title: "Import file"
		folder: shortcuts.home
		selectExisting: true
		selectMultiple: false
		selectFolder: false
		nameFilters: [ "Map files (*.map)" ]

		onAccepted: {
			mapProvider.importFrom(importFileDialog.fileUrl)
			scene.loadMap(mapProvider.map)
		}
	}

	MapProvider {
		id: mapProvider
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
					exportFileDialog.open()
				}
			}
			Button {
				text: "Import"
				onClicked: {
					importFileDialog.open()
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
				id: layerComboBox
				model:mapProvider.layers
			}
		}

		RowLayout {
			Item {
				id: viewport
				Scene {
					id: scene
				}

				property var selectedLayer
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
							var ijObj = scene.xyToIj(mouseX, mouseY)
							if(mouse.button == Qt.RightButton) {
								scene.removeItem(scene.layerAt(layerComboBox.currentText), ijObj.i, ijObj.j)
								viewport.selectedLayer = null
								viewport.selectedItem = null
							} else {
//								var result = scene.hitTest(mouseX, mouseY)
//								if(result.item) {
//									viewport.selectedItem = result.item
//									viewport.selectedLayer = result.layer
//								}
								scene.addItem(scene.layerAt(layerComboBox.currentText), ijObj.i, ijObj.j, boxTypeComboBox.boxType)
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

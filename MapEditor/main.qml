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

				Rectangle {
					width: 320
					height: 320
					color: "transparent"
					border {
						color: "red"
						width: 1
					}

//					SelectTool {
//						id: selectTool
//						scene: scene
//						anchors.fill: parent
//					}

					BuildTool {
						id: buildTool
						scene: scene
						mapProvider: mapProvider

						layerName: layerComboBox.currentText
						boxType: boxTypeComboBox.boxType

						anchors.fill: parent
					}
				}
			}
		}
	}
}

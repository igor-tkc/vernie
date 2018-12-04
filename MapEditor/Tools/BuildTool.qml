import QtQuick 2.9

import "qrc:///Scene"

Item {
	id: root

	property Scene scene
	property MapProvider mapProvider

	property string layerName
	property int boxType

	function buildItem(x, y) {
		var ijObj = scene.xyToIj(x, y)
		mapProvider.putData(layerName, ijObj.i, ijObj.j, boxType)
		scene.addItem(scene.layerAt(layerName), ijObj.i, ijObj.j, boxType)
	}

	function removeItem(x, y) {
		var ijObj = scene.xyToIj(x, y)
		mapProvider.putData(layerName, ijObj.i, ijObj.j, -1)
		scene.removeItem(scene.layerAt(layerName), ijObj.i, ijObj.j)
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		acceptedButtons: Qt.LeftButton | Qt.RightButton

		onPressed: {
			if(mouseArea.pressedButtons & Qt.LeftButton) {
				buildItem(mouseX, mouseY)
			} else {
				removeItem(mouseX, mouseY)
			}
		}

		onPositionChanged: {
			if(mouseArea.pressedButtons & Qt.LeftButton) {
				buildItem(mouseX, mouseY)
			} else {
				removeItem(mouseX, mouseY)
			}
		}
	}
}

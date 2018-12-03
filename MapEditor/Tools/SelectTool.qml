import QtQuick 2.9
import QtQml 2.2

import "qrc:///Scene"

Item {
	id: root

	property Scene scene
	property Box item

	MouseArea {
		anchors.fill: parent
		acceptedButtons: Qt.AllButtons

		function selectAt(x, y) {
			var ijData = scene.xyToIj(mouseX, mouseY)
			var items = scene.itemsAt(ijData.i, ijData.j)
			if(items && items.length) {
				root.item = items[items.length - 1].item
			} else {
				root.item = null
			}
		}

		onPressed: {
			console.log("SelectTool::onPressed")
			selectAt(mouseX, mouseY)

		}

		onPositionChanged: {
			console.log("SelectTool::onPositionChanged")
			if(pressed) {
				selectAt(mouseX, mouseY)
			}
		}

		onReleased: {
			console.log("SelectTool::onReleased")
			selectAt(mouseX, mouseY)
		}
	}

	Rectangle {
		visible: root.item
		color: "transparent"
		border.color: "red"
		border.width: 2

		x: root.item && root.item.x || 0
		y: root.item && root.item.y || 0
		width: root.item && root.item.width || 0
		height: root.item && root.item.height || 0
	}
}

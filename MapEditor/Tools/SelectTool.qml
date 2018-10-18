import QtQuick 2.9
import QtQml 2.2

import "qrc:///Scene"

Item {
	id: root

	property Scene scene

	MouseArea {
		anchors.fill: parent
		acceptedButtons: Qt.AllButtons

		onPressed: {
			console.log("SelectTool::onPressed")
//			var value = targetBox
//			if(pressedButtons & Qt.RightButton) {
//				value = 0
//			}

//			var p = hitTest(mouse.x, mouse.y)
//			setBox(value, p.x, p.y)
		}
		onPositionChanged: {
			console.log("SelectTool::onPositionChanged")
//			var value = targetBox
//			if(pressedButtons & Qt.RightButton) {
//				value = 0
//			}

//			var p = hitTest(mouse.x, mouse.y)
//			setBox(value, p.x, p.y)
		}
		onReleased: {
			console.log("SelectTool::onReleased")
		}
	}
}

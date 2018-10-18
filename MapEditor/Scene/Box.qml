import QtQuick 2.0
import "qrc:///App/App.js" as App

Item {
	id: root

	property int type

	Image {
		id: image
		smooth: true
		source: App.instance.imageLibrary.sourceAt(root.type)
	}
}

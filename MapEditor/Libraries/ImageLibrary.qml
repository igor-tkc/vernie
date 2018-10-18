import QtQuick 2.11

QtObject {
	id: root

//	https://www.textures.com
	property var sources: ({
							   0: "qrc:///Resources/stone.jpg"
							   , 1: "qrc:///Resources/grass.jpg"
							   , 2: "qrc:///Resources/block.jpg"
							   , 3: "qrc:///Resources/tree.png"
						   })

	function sourceAt(type) {
		var result = sources[type]
		return result
	}
}

import QtQuick 2.11

QtObject {
	id: root

	readonly property var layers: map && findLayers(map) || []
	property var map

	function findLayers(map) {
		var result = []
		if(map !== null) {
			for(var i = 0; i < map.length; ++i) {
				result.push(map[i].name)
			}
		}
		return result
	}

	function putData(layerName, i, j, data) {
		for(var k = 0; k < map.length; ++k) {
			var layerData = map[k]
			if(layerData.name === layerName) {
				layerData.source[i][j] = data
				break
			}
		}
	}

	function exportTo(filePath) {
		console.log("MapProvider::exportTo::filePath:", filePath)
		var data = JSON.stringify(root.map)
		var request = new XMLHttpRequest()
		request.open("PUT", filePath, false)
		request.send(data)
		return request.status
	}

	function importFrom(filePath) {
		console.log("MapProvider::importFrom::filePath:", filePath)
		var request = new XMLHttpRequest()
		request.open("GET", filePath, false)
		request.send(null)
		if(request.status === 200) {
			var data = JSON.parse(request.responseText)
			root.map = data
		}
		return request.status
	}

	function generateMap(width, height) {
		console.log(qsTr("MapProvider::generateMap::width:%1, height:%2").arg(width).arg(height))

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
				type = -1
				layer.source[ii].push(type)
			}
		}
		map = result
	}
}

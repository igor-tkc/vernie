import QtQuick 2.9

Item {
	property Component layerComponent: Layer {

	}

	id: root
	property var map
	property real itemWidth: 32
	property real itemHeight: 32

	function xyToIj(x, y) {
		return {
			"i": Math.floor(x / root.itemWidth)
			, "j": Math.floor(y / root.itemHeight)
		}
	}

	function loadMap(map) {
		for(var i = root.children.length - 1; i >= 0; --i) {
			root.children[i].resetItems()
			root.children[i].destroy()
		}

		root.map = map

		for(var iLayer = 0; iLayer < map.length; ++iLayer) {
			var layerData = map[iLayer]
			var layer = layerComponent.createObject(root, {"name": layerData.name})
			layer.resetItems(layerData.source)
		}
	}

	function removeItem(layer, i, j) {
		if(layer)
			layer.removeItem(i, j)
	}

	function addItem(layer, i, j, data) {
		if(layer)
			layer.addItem(i, j, data)
	}

	function nextLayer(layer) {
		for(var i = 0; i < root.children.length - 1; ++i) {
			if(root.children[i] === layer) {
				return root.children[i + 1]
			}
		}
		return null
	}

	function layerAt(name) {
		for(var i = root.children.length - 1; i >= 0; --i) {
			var layer = children[i]
			if(layer.name === name)
				return layer
		}
		return null
	}

	function itemsAt(i, j) {
		var result = []
		for(var li = root.children.length - 1; li >= 0; --li) {
			var layer = children[li]
			var item = layer.itemAt(i, j)
			if(item) {
				result.push({
								"layer": layer
								, "item": item
							})
			}
		}
		return result
	}
}

import QtQuick 2.0

Item {
	id: root

	property string name: ""
	property real itemWidth: 32
	property real itemHeight: 32
	property Component itemComponent: Box {}

	QtObject {
		id: d

		property var items: []

		function itemAt(i, j) {
			if(items && items.length && items.length > i
					&& items[i] && items[i].length && items[i].length > j)
				return items[i][j]
			return null
		}

		function releaseItem(i, j) {
			if(items && items.length && items.length > i
					&& items[i] && items[i].length && items[i].length > j) {
				items[i][j] = null
			}
		}

		function indexOf(item) {
			if(items == null)
				return null

			for(var i = 0; i < items.length; ++i)
				for(var j = 0; j < items[i].length; ++j) {
					if(items[i][j] === item) {
						return {"i": i, "j": j}
					}
				}

			return null
		}

		function clean() {
			if(items == null)
				return

			items.forEach(function(items) {
				items.forEach(function(item) {
					if(item) {
						item.destroy()
					} else {
						// This item was stolen
					}
				})
			})

			items = []
		}
	}

	function hitTest(x, y) {
		var i = Math.floor(x / root.itemWidth)
		var j = Math.floor(y / root.itemHeight)
		if(i < 0 || i >= d.items.length) {
			return null
		}
		if(j < 0 || j >= d.items[0].length) {
			return null
		}

		return d.items[i][j]
	}

	function removeItem(i, j) {
		if(d.items[i][j]) {
			d.items[i][j].destroy()
			d.items[i][j] = null
		}
	}

	function addItem(i, j, data) {
		if(d.items[i][j] !== null) {
			removeItem(i, j)
		}

		var result = createItem(i, j, data)
		d.items[i][j] = result
		return result
	}

	function createItem(i, j, data) {
		var result = itemComponent.createObject(root, {
													"x": i * root.itemWidth
													, "y": j * root.itemHeight
													, "type": data
													, "width": root.itemWidth
													, "height": root.itemHeight
												})
		return result
	}

	function resetItems(source) {
		if(!source) {
			d.clean()
			return
		}

		console.time("Layer::resetItems")
		var result = []
		var item = null
		for(var i = 0; i < source.length; ++i) {
			result.push([])
			for(var j = 0; j < source[i].length; ++j) {
				var data = source[i][j]
				item = d.itemAt(i, j)
				if(item) {
					d.releaseItem(i, j)
					item.source = data

					result[i].push(item)
				} else {
					var w = 20
					var h = 20
					if(data !== -1) {
						item = createItem(i, j, data)
					} else {
						item = null
					}

					result[i].push(item)
				}
			}
		}

		d.clean()
		d.items = result
		console.timeEnd("Layer::resetItems")
	}
}

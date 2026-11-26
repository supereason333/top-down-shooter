extends Resource
class_name ItemContainer

signal items_changed

@export var size:Vector2i

var items:Array[ItemData]
var item_rects:Array[Rect2i]
var grid:Array[Array]	# Array[Array[bool]]

func _init() -> void:
	grid.resize(size.x)
	for cx in grid:
		cx.resize(size.y)
		cx.fill(false)

# Adds to the container, at the selected position else random
func add_item(item:ItemData, pos:Vector2i = Vector2i(-1, -1)) -> bool:
	var rect:Rect2i
	if pos == Vector2i(-1, -1):
		pos = get_first_free(item.size)
		if pos == Vector2i(-1, -1): return false
		rect = Rect2i(pos, item.size)
	else:
		rect = Rect2i(pos, item.size)
		if !check_grid(rect): return false

	set_area(rect, true)
	items.append(item)
	item_rects.append(rect)
	items_changed.emit()
	return true

# gets ref to item
func get_at_point(vec:Vector2i) -> ItemData:
	for i in item_rects.size():
		if item_rects[i].has_point(vec):
			return items[i]
	return null

# gets index to item
func get_index_at_point(vec:Vector2i) -> int:
	for i in item_rects.size():
		if item_rects[i].has_point(vec):
			return i
	return -1

# gets ref to item, removes from container
func remove_item(i:int) -> ItemData:
	if i < 0 or i >= items.size():
		return null
	var item := items[i]
	var rect := item_rects[i]
	items.remove_at(i)
	item_rects.remove_at(i)
	set_area(rect, false)
	items_changed.emit()
	return item

# gets ref and removes from container
func remove_item_at_point(vec:Vector2i) -> ItemData:
	var i := get_index_at_point(vec)
	if i == -1: return null
	return remove_item(i)

# checks whether rect can fit on grid
func check_grid(rect:Rect2i) -> bool:
	var r := Rect2i(Vector2i.ZERO, size)
	if !r.has_point(rect.end) or !r.has_point(rect.position): return false
	for cx in range(rect.position.x, rect.end.x):
		for ry in range(rect.position.y, rect.end.y):
			if grid[cx][ry]: return false
	return true

# sets an rect with filled
func set_area(rect:Rect2i, filled:bool):
	var r := Rect2i(Vector2i.ZERO, size)
	rect = r.intersection(rect)
	for cx in range(rect.position.x, rect.end.x):
		for ry in range(rect.position.y, rect.end.y):
			grid[cx][ry] = filled

# gets the first filled
# dumb search, doesnt rearrange stuff
func get_first_free(item_size:Vector2i) -> Vector2i:
	if item_size.x > size.x or item_size.y > size.y: return Vector2i(-1, -1)

	for cx in grid.size() - item_size.x:
		for ry in grid[cx].size() - item_size.y:
			if check_grid(Rect2i(Vector2i(cx, ry), item_size)):
				return Vector2i(cx, ry)
	return Vector2i(-1, -1)

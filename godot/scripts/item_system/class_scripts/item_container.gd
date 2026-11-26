extends Resource
class_name ItemContainer

signal items_changed
signal item_added(item:ItemData)
signal item_removed(item:ItemData)

@export var name:String
@export var size:Vector2i:
	set(value):
		size = value
		_build_grid()
@export var allow_containers:bool = false
@export var filter:ItemFilter

var items:Array[ItemData]
var item_rects:Array[Rect2i]
var grid:Array[Array]	# Array[Array[bool]]

func _build_grid() -> void:
	grid.resize(size.x)
	for cx in grid:
		cx.resize(size.y)
		cx.fill(false)

## chekcs the criteria for the container to see whether item can be added or not,
## if checking location use check_grid
func can_add(item:ItemData) -> bool:
	if item is ContainerItem:
		if !allow_containers: return false
	if filter: return filter.filter(item.id)
	return true

# Adds to the container, at the selected position else random
func add_item(item:ItemData, pos:Vector2i = Vector2i(-1, -1)) -> bool:
	# if item is ContainerItem and !allow_containers: return false
	if !can_add(item): return false
	var rect:Rect2i
	var master := item.get_master()
	if pos == Vector2i(-1, -1):
		pos = get_first_free(master.size)
		if pos == Vector2i(-1, -1): return false
		rect = Rect2i(pos, master.size)
	else:
		rect = Rect2i(pos, master.size)
		if !check_grid(rect): return false

	set_area(rect, true)
	items.append(item)
	item_rects.append(rect)
	items_changed.emit()
	item_added.emit(item)
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
	item_removed.emit(item)
	return item

# gets ref and removes from container
func remove_item_at_point(vec:Vector2i) -> ItemData:
	var i := get_index_at_point(vec)
	if i == -1: return null
	return remove_item(i)

# checks whether rect can fit on grid
func check_grid(rect: Rect2i) -> bool:
	var r := Rect2i(Vector2i.ZERO, size)
	if not r.encloses(rect):
		return false
	for cx in range(rect.position.x, rect.end.x):
		for ry in range(rect.position.y, rect.end.y):
			if grid[cx][ry]:
				return false
	return true

# gets the first filled
# dumb search, doesnt rearrange stuff
func get_first_free(item_size: Vector2i) -> Vector2i:
	if item_size.x > size.x or item_size.y > size.y:
		return Vector2i(-1, -1)

	for cx in grid.size() - item_size.x + 1:
		for ry in grid[cx].size() - item_size.y + 1:
			if check_grid(Rect2i(Vector2i(cx, ry), item_size)):
				return Vector2i(cx, ry)
	return Vector2i(-1, -1)

# sets an rect with filled
func set_area(rect:Rect2i, filled:bool):
	var r := Rect2i(Vector2i.ZERO, size)
	rect = r.intersection(rect)
	for cx in range(rect.position.x, rect.end.x):
		for ry in range(rect.position.y, rect.end.y):
			grid[cx][ry] = filled

func get_mass() -> float:
	var sum := 0.0
	for item in items:
		if item is ContainerItem:
			sum += item.net_mass
		else:
			sum += item.mass
	return sum

func get_container_items() -> Array[ContainerItem]:
	var arr:Array[ContainerItem]
	for item in items:
		if item is ContainerItem:
			arr.append(item)
	return arr

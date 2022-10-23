extends Node

export (Rect2) var wrap_area = null
export(bool) var horizontal_wrapping = true
export(bool) var vertical_wrapping = true

const AXIS = {
	HORIZONTAL = "x",
	VERTICAL = "y"
}

func initWrapArea():
	if wrap_area == null:
		wrap_area = Rect2(Vector2(), get_viewport().size)

func _ready():
	initWrapArea()
	add_to_group("wrap_around")

func _process(_delta):
	if !wrap_area.has_point(get_parent().global_position):
		wrap()

func wrap():
	if horizontal_wrapping:
		wrapBy(AXIS.HORIZONTAL)
	if vertical_wrapping:
		wrapBy(AXIS.VERTICAL)

func getAxisWrapDirection(axis):
	if get_parent().global_position[axis] < wrap_area.position[axis]:
		return 1
	elif get_parent().global_position[axis] > wrap_area.size[axis]:
		return -1
	return 0

func wrapBy(axis):
	var adjust = getAxisWrapDirection(axis) * wrap_area.size[axis]
	get_parent().position[axis] += adjust

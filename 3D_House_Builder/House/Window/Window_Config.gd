@tool
extends Resource
class_name Window_Config

@export var horizontal_position : float = 0.5:
	set(value):
		horizontal_position = value
		emit_changed()

@export var vertical_position : float = 0.5:
	set(value):
		vertical_position = value
		emit_changed()

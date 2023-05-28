@tool
extends Resource
class_name Pillar_Config

@export var position : Vector3 :
	set(value):
		position = value
		emit_changed()

@export var height : float = 2.0:
	set(value):
		height = value
		emit_changed()

@export var width : float = 0.5:
	set(value):
		width = value
		emit_changed()
		
@export var material : StandardMaterial3D:
	set(value):
		material = value
		emit_changed()
		


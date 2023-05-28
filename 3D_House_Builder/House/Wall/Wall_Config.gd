@tool
extends Resource
class_name Wall_Config

@export var pillar_1 : int :
	set(value):
		pillar_1 = value
		emit_changed()

@export var pillar_2 : int:
	set(value):
		pillar_2 = value
		emit_changed()
		
@export var width : float = 1.0:
	set(value):
		width = value
		emit_changed()
	

@export var windows : Array[Window_Config] :
	set(value):
		windows = value
		for w in windows:
			w.changed.connect(emit_changed)
		emit_changed()
	

@export var material : StandardMaterial3D:
	set(value):
		material = value
		emit_changed()
		

@export var inner_material : StandardMaterial3D:
	set(value):
		inner_material = value
		emit_changed()		


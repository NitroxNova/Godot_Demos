@tool
extends Resource
class_name House_Config

@export var pillars : Array[Pillar_Config] :
	set(value):
		pillars = value
		for p in pillars:
			p.changed.connect(emit_changed)
		emit_changed()
		
@export var walls : Array[Wall_Config] :
	set(value):
		walls = value
		for w in walls:
			w.changed.connect(emit_changed)
		emit_changed()

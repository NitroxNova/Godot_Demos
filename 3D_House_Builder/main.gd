@tool
extends Node3D

var pillar_scene = preload("res://House/Pillar/pillar.tscn")
var wall_scene = preload("res://House/Wall/wall.tscn")
var window_scene = preload("res://House/Window/window.blend")
var window_cutout_scene = preload("res://House/Window/cut_out.tscn")

@export var house_config : House_Config :
	set(value):
		house_config = value
		house_config.changed.connect(build)
		build()

func _ready():
	build()

func build():
	clean_house()
	for p in house_config.pillars:
		build_pillar(p)
	for w in house_config.walls:
		build_wall(w)
		
func clean_house():
	for child in $House.get_children():
		child.queue_free()

func build_pillar(p_config):
	var pillar = pillar_scene.instantiate()
	pillar.set_position(p_config.position)
	pillar.set_height(p_config.height)
	pillar.set_width(p_config.width)
	pillar.set_material(p_config.material)
	$House.add_child(pillar)
	
func build_wall(wall_config:Wall_Config):
	var wall = wall_scene.instantiate()
	var pillar_1 = house_config.pillars[wall_config.pillar_1]
	var pillar_2 = house_config.pillars[wall_config.pillar_2]
	wall.position = (pillar_1.position + pillar_2.position) / 2
	var length = pillar_1.position.distance_to(pillar_2.position)
	wall.set_length(length)
	var height = min(pillar_1.height,pillar_2.height)
	wall.set_height(height)
	var width = min(pillar_1.width, pillar_2.width)
	width *= wall_config.width
	wall.set_width(width)
	wall.set_material(wall_config.material)
	wall.set_inner_material(wall_config.inner_material)
	var wall_angle = (pillar_1.position - pillar_2.position).angle_to(Vector3.FORWARD)
	if pillar_1.position.x > pillar_2.position.x:
		wall_angle = 2 * PI - wall_angle
	wall.rotation = Vector3(0,wall_angle,0)
	for w in wall_config.windows:
		var window = window_scene.instantiate()
		var cutout = window_cutout_scene.instantiate()
		var window_y = w.vertical_position * height
		var window_z = (w.horizontal_position - 0.5) * length
		var window_position = Vector3(0,window_y,window_z)
		window.position = window_position
		cutout.position = window_position
		cutout.material = wall_config.material
		wall.add_child(cutout)
		wall.add_child(window)
	$House.add_child(wall)

func _on_visibility_changed():
	build()

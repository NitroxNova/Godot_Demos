@tool
extends Node3D

func set_height(height:float):
	$Mesh.height = height
	$Mesh.position.y = height/2
	
func set_material(material):
	$Mesh.material = material

func set_width(width:float):
	$Mesh.radius = width / 2

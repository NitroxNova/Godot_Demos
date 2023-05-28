@tool
extends CSGCombiner3D

func set_length(length:float):
	$Mesh.size.z = length
	$Inner.size.z = length
	
func set_height(height:float):
	$Mesh.size.y = height
	$Mesh.position.y = height/2
	$Inner.size.y = height
	$Inner.position.y = height/2
	
func set_width(width:float):
	$Mesh.size.x = width
	$Inner.position.x = width /2
	
func set_material(material):
	$Mesh.material = material
	
func set_inner_material(material):
	if material == null:
		$Inner.hide()
	else:
		$Inner.show()
		$Inner.material = material

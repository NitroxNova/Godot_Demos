extends Resource
class_name Snowflake_Segment

func reflect_coords(coord_list:PackedVector2Array):
	var new_list = PackedVector2Array()
	for coord in coord_list:
		coord.x *= -1
		new_list.append(coord)
	return new_list	
	
	
func rotate_coords(coord_list:PackedVector2Array):
	var new_list = PackedVector2Array()
	for coord in coord_list:
		var new_coord = coord.rotated(PI/3)
		new_list.append(new_coord)
	return new_list	

extends Snowflake_Segment
class_name Snowflake_Branch

var start : Vector3i
var end : Vector3i
var grid : Snowflake_Grid

func _init(pos:Vector3i,g:Snowflake_Grid):
	start = pos
	end = pos
	grid = g
	
func add_cell(pos:Vector3i):
	end = pos



func draw(node:Node2D):
	var start_pos = grid.xy_coords(start)
	var end_pos = grid.xy_coords(end)
	var coords = PackedVector2Array([start_pos,end_pos])
	var reflect_coords = reflect_coords(coords)
	for i in 6:
		node.draw_line(coords[0],coords[1],Color.WHITE,grid.cell_radius*2)
		node.draw_line(reflect_coords[0],reflect_coords[1],Color.WHITE,grid.cell_radius*2)
		coords = rotate_coords(coords)
		reflect_coords = rotate_coords(reflect_coords)
	

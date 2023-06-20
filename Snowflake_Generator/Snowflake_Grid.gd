extends Hex_Grid
class_name Snowflake_Grid

enum {NONE,FACET,BRANCH,FACET_BRANCH}

func is_facet(pos:Vector3i):
	if cells[pos] == FACET or cells[pos] == FACET_BRANCH:
		return true
	return false

func is_branch(pos:Vector3i):
	if cells[pos] == BRANCH or cells[pos] == FACET_BRANCH:
		return true
	return false

#func set_cell(pos:Vector3i,value):
#	var reflect_pos = reflect_cell(pos)
#	for i in 6:
#		super(pos,value)
#		super(reflect_pos,value)
#		pos = rotate_cell(pos)
#		reflect_pos = rotate_cell(reflect_pos)

		
func in_ne_top(pos:Vector3i):
	if not is_valid(pos):
		return false
	if pos.x < 0:
		return false
	elif pos.z < 0:
		return false
	elif pos.x > pos.z:
		return false
	return true
	
func draw_cells(node:Node2D):
	for cell_pos in cells:
		var xy_pos = xy_coords(cell_pos)
		var cell = cells[cell_pos]
		var color = Color.WHITE
		if cell == FACET:
			color = Color.RED
		elif cell == BRANCH:
			color = Color.BLUE
		elif cell == FACET_BRANCH:
			color = Color.PURPLE
		draw_hexagon(xy_pos,color,node)	

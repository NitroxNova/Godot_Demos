extends Snowflake_Segment
class_name Snowflake_Facet

var cells = []
var grid : Snowflake_Grid
var growable = PackedVector3Array()
var origin : Vector3i

func _init(pos:Vector3i, g:Snowflake_Grid):
	grid = g
	origin = pos
#	add_cell(pos)
	cells.append(pos)
	growable = grid.get_neighbors(pos)

func add_cell(pos:Vector3i):
	if not pos in cells:
		cells.append(pos)
		
		growable.remove_at(growable.find(pos))
		for nb in grid.get_neighbors(pos):
			if not nb in growable and not nb in cells:
				growable.append(nb)

func get_outline():
	var perimeter = []
	var top_cell = north_cell()
	top_cell = grid.next_cell_pos(top_cell,0)
	var next_cell = {pos=top_cell,dir=3}
	while not next_cell.pos in perimeter:
		perimeter.append(next_cell.pos)
		next_cell = increment_perimeter(next_cell.pos,next_cell.dir)
	perimeter.append(next_cell.pos)
	
	var poly = PackedVector2Array()
	for pos in perimeter:
		poly.append(grid.xy_coords(pos))
	return poly
	
	
func increment_perimeter(pos:Vector3i,dir:int):
	for i in 6:
		dir = (dir + 1) % 6
		var next_pos = grid.next_cell_pos(pos,dir)
		if not next_pos in cells:
			dir = (dir + 3) % 6
			return {pos=next_pos,dir=dir}
	
func north_cell():
	var top_cell = 0
	for cell_index in cells.size():
		if cells[cell_index].z > cells[top_cell].z:
			top_cell = cell_index
	return cells[top_cell]
		

func grow():
	var dupe_cells = growable.duplicate()
	for cell in dupe_cells:
		var next_cell = grid.get_cell(cell)
		var nb_count = count_neighbor_facets(cell)
		var grow_chance = nb_count/6.0
		if grid.in_ne_top(cell):
			if randf() < grow_chance:
				if next_cell == null:
					grid.set_cell(cell,grid.FACET)
					add_cell(cell)
				elif next_cell == grid.BRANCH:
					grid.set_cell(cell,grid.FACET_BRANCH)
					add_cell(cell)
			
func count_neighbor_facets(cell):
	var nb_list = grid.get_neighbors(cell)
	var nb_count = 0
	for nb in nb_list:
		if nb in cells:
			nb_count += 1
	return nb_count

func draw(node:Node2D, color:Color):
	var poly = get_outline()
	var reflect_poly = reflect_coords(poly)
	for i in 6:
		node.draw_polyline(poly,Color.BLACK,2)
		node.draw_colored_polygon(poly,color)
		node.draw_polyline(reflect_poly,Color.BLACK,2)
		node.draw_colored_polygon(reflect_poly,color)
		poly = rotate_coords(poly)
		reflect_poly = rotate_coords(reflect_poly)

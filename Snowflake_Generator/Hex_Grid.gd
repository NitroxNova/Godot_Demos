extends Resource
class_name Hex_Grid

var cells : Dictionary
var cell_radius : float = 30
var size : int = 5
enum {NORTH_EAST,EAST,SOUTH_EAST,SOUTH_WEST,WEST,NORTH_WEST}

func _init(s:int,cr:float):
	size = s
	cell_radius = cr

func set_cell(pos:Vector3i,value):
	cells[pos] = value

func is_set(pos:Vector3i):
	return pos in cells
	
func get_cell(pos:Vector3i):
	if is_set(pos):
		return cells[pos]
	return null
	
func reflect_cell(pos:Vector3i):
	var x = pos.x * -1
	var y = pos.z * -1
	var z = pos.y * -1
	return Vector3i(x,y,z)
	
func rotate_cell(pos:Vector3i):
	var x = pos.y * -1
	var y = pos.z * -1
	var z = pos.x * -1
	return Vector3i(x,y,z)	
	
func get_neighbors(pos:Vector3i):
	var nb_cells : Array[Vector3i] = []
	for i in 6:
		var next_pos = next_cell_pos(pos,i)
		if is_valid(next_pos):
			nb_cells.append(next_pos)
	return nb_cells
	
func next_cell_pos(pos:Vector3i,direction:int):
	match direction:
		NORTH_EAST:
			return pos + Vector3i(0,-1,1)
		EAST:
			return pos + Vector3i(1,-1,0)
		SOUTH_EAST:
			return pos + Vector3i(1,0,-1)
		SOUTH_WEST:
			return pos + Vector3i(0,1,-1)
		WEST:
			return pos + Vector3i(-1,1,0)
		NORTH_WEST:
			return pos + Vector3i(-1,0,1)
	
func is_valid(pos:Vector3i):
	if pos.x > size:
		return false
	elif pos.y > size:
		return false
	elif pos.z > size:
		return false
	elif pos.x < size*-1:
		return false
	elif pos.y < size*-1:
		return false
	elif pos.z < size*-1:
		return false
	elif not pos.x + pos.y + pos.z == 0:
		return false
	return true
	

func xy_coords(pos:Vector3i):
	var x = pos.x - pos.y
	var y = pos.z
	var xy_coords = Vector2(x,y)
	var x_offset = sqrt(3)/2 * cell_radius
	var y_offset = -1.5 * cell_radius
	xy_coords *= Vector2(x_offset,y_offset)
	return xy_coords

func draw_cells(node:Node2D):
	for cell_pos in cells:
		var xy_pos = xy_coords(cell_pos)
		var color = get_cell(cell_pos)
		draw_hexagon(xy_pos,color,node)
		
func draw_hexagon(pos:Vector2,color:Color,node:Node2D):
	var poly = PackedVector2Array()
	for i in 6:
		var coord = Vector2(0,cell_radius)
		coord = coord.rotated((PI/3)*i)
		coord += pos
		poly.append(coord)
	node.draw_colored_polygon(poly,color)
	
func distance_from_center(pos:Vector3i):
	var x = abs(pos.x)
	var y = abs(pos.y)
	var z = abs(pos.z)
	return max(x,y,z)
	
func percent_from_center(pos:Vector3i):
	var dist : float = distance_from_center(pos)
	return dist/size
	

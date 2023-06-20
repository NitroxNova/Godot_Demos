extends Node2D

var grid = Snowflake_Grid.new(50,6)
var facets:Array[Snowflake_Facet] = []
var branches : Array[Snowflake_Branch] = []
var color_gradient = Gradient.new()

func _init():
	build_branches()
	build_facets()
	color_gradient.set_color(0,random_blue_color())
	color_gradient.set_color(1,random_blue_color())
	
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		get_tree().reload_current_scene()	
		
func rand_dict(dict:Dictionary):
	var keys = dict.keys()
	var index = randi() % keys.size()
	return keys[index]
	
func build_facets():
	for i in 20:
		var pos = rand_dict(grid.cells)
		while pos in facets:
			pos = rand_dict(grid.cells)
		var facet = Snowflake_Facet.new(pos,grid)
		grid.set_cell(pos,grid.FACET_BRANCH)
		facets.append(facet)
		
	for i in 10:
		grow_facets()
		
func grow_facets():
	for f in facets:
		f.grow()

				
func build_branches():
	var pos = Vector3i.ZERO
	var fork_chance = .20
	var can_fork = true
	branches.append(Snowflake_Branch.new(pos,grid))
	while grid.is_valid(pos):
		grid.set_cell(pos,grid.BRANCH)
		branches[0].add_cell(pos)
		if can_fork:
			if randf() < fork_chance:
				build_side_branch(pos)
				can_fork = false
		else:
			can_fork = true
		pos = grid.next_cell_pos(pos,grid.NORTH_EAST)

func build_side_branch(pos:Vector3i):
	var branch_end = false
	var branch_end_chance = .18
	var branch = Snowflake_Branch.new(pos,grid)
	while grid.in_ne_top(pos) and not branch_end:
		grid.set_cell(pos,grid.BRANCH)
		branch.add_cell(pos)
		pos = grid.next_cell_pos(pos,grid.EAST)
		if randf() < branch_end_chance:
			branch_end = true
	branches.append(branch)	
	
func random_blue_color():
	var color : Color
	color.r = randf_range(0,1)
	color.g = randf_range(color.r,1)
	color.b = 1
	color.a = .5
	return color
		

func _draw():
#	grid.draw_cells(self)
	for b in branches:
		b.draw(self)
	for f in facets:
		var color = color_gradient.sample(grid.percent_from_center(f.origin))
		f.draw(self,color)



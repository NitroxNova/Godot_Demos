extends Node2D

var player_speed = 350
var move_keys = {"up":Vector2.UP,"down":Vector2.DOWN,"left":Vector2.LEFT,"right":Vector2.RIGHT}
var current_spell = null
var FOV_increment = 2 * PI / 60
onready var Spells = {Single_Target=$Spell_Bar/Single_Target,Ranged_AOE=$Spell_Bar/Ranged_AOE,Swivel_Cone=$Spell_Bar/Swivel_Cone}
onready var space_state = get_world_2d().direct_space_state
enum Draw_Target_State {Player_Moved, Mouse_Moved, Spell_Selected, Spell_Canceled}

func _ready():
	for button in Spells.values():
		button.connect("pressed",self,"select_spell",[button])

func _process(delta):
	$Spell_Bar/Label.text = "FPS: "+str(Engine.get_frames_per_second())+"\nEsc to Cancel"
	if Input.is_action_just_pressed("ui_cancel"):
		cancel_spell()
	
func _physics_process(delta):
	var velocity = Vector2.ZERO
	for key in move_keys:
		if Input.is_action_pressed(key):
			velocity += move_keys[key]
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized()
		velocity *= player_speed
		$Player.move_and_slide(velocity)
		draw_target_area(Draw_Target_State.Player_Moved)
		
func draw_target_area(state):
	var S = Draw_Target_State
	if state == S.Spell_Selected:
		clear_secondary_target_area()
	if current_spell == Spells.Single_Target:
		if state == S.Spell_Selected or state == S.Player_Moved:
			set_primary_target_area(get_FOV_circle($Player.global_position,300))
	elif current_spell == Spells.Ranged_AOE:
		if state == S.Spell_Selected or state == S.Player_Moved:
			set_primary_target_area(get_FOV_circle($Player.global_position,200))
		if state == S.Mouse_Moved:
			set_secondary_target_area(get_FOV_circle(get_global_mouse_position(),100))
	elif current_spell == Spells.Swivel_Cone:
		if state == S.Spell_Selected or state == S.Player_Moved or state == S.Mouse_Moved: 
			var mouse_angle = get_global_mouse_position().angle_to_point($Player.global_position)
			set_primary_target_area(get_FOV_cone($Player.global_position,250,1,mouse_angle))
	else:
		clear_target_area()
		
func get_FOV_circle(from:Vector2,radius):
	return raycast_arc(from,radius,FOV_increment,2*PI)
	
func get_FOV_cone(from:Vector2,radius,width:float,angle):
	var start_angle = angle - width/2
	var end_angle = angle + width/2
	var points = raycast_arc(from,radius,start_angle,end_angle)
	points.append(from)
	return points
	
func raycast_arc(from:Vector2,radius,start_angle,end_angle):
	var angle = start_angle	
	var points = PoolVector2Array()
	while angle < end_angle:
		var offset = Vector2(radius,0).rotated(angle)
		var to = from + offset
		var result = space_state.intersect_ray(from,to,[],2)
		if result:
			points.append(result.position)
		else:
			points.append(to)
		angle += FOV_increment
	return points
		
func set_primary_target_area(points:PoolVector2Array):
	$Target_Area/Primary/Polygon2D.polygon = points
	$Target_Area/Primary/CollisionPolygon2D.polygon = points
	
func set_secondary_target_area(points:PoolVector2Array):
	$Target_Area/Secondary/Polygon2D.polygon = points
	$Target_Area/Secondary/CollisionPolygon2D.polygon = points
		
func select_spell(button:Button):
	if current_spell != null:
		current_spell.disabled = false
	button.disabled = true
	current_spell = button
	draw_target_area(Draw_Target_State.Spell_Selected)

func cancel_spell():
	if current_spell != null:
		current_spell.disabled = false
		current_spell = null
		draw_target_area(Draw_Target_State.Spell_Canceled)

func target_area_input(viewport, event:InputEvent, shape_idx):
	if event.is_action_pressed("click"):
		var targets = []
		if current_spell == Spells.Single_Target:
			var result = space_state.intersect_point(get_global_mouse_position())
			for r in result:
				targets.append(r.collider)
		elif current_spell == Spells.Ranged_AOE:
			targets = $Target_Area/Secondary.get_overlapping_bodies()
		elif current_spell == Spells.Swivel_Cone:
			targets = $Target_Area/Primary.get_overlapping_bodies()
		for t in targets:
			if t != $Player:
				t.queue_free()
		cancel_spell()
	elif event is InputEventMouseMotion:
		draw_target_area(Draw_Target_State.Mouse_Moved)

func _on_Target_Area_mouse_entered():
	$Target_Area/Primary/Polygon2D.color = Color(0,0,1,0.3)

func _on_Target_Area_mouse_exited():
	$Target_Area/Primary/Polygon2D.color = Color(1,0,0,0.3)
	clear_secondary_target_area()

func clear_target_area():
	clear_primary_target_area()
	clear_secondary_target_area()

func clear_primary_target_area():
	set_primary_target_area(PoolVector2Array())

func clear_secondary_target_area():
	set_secondary_target_area(PoolVector2Array())

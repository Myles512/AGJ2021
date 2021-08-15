extends Node2D

#scene settings
export(PackedScene) var laser_scene
export var rotate_speed = 0.01
export var laser_distance = 500
export(bool) var on = true
var powerSources = []

#debug stuff
export var debug_drawraycast = false

var mouse_in_rotate = false
var mouse_in_drag = false
var dragging = false
var rotating = false
var next_laser = null
var root_node
var pickup_start_pos = null
var can_drop_here = false

func _ready():
	root_node = get_tree().get_current_scene()
	updatePowerState()


func _physics_process(_delta):
	if on:
		make_laser()
		next_laser.visible = true
	var overlapping_bodies = $TurretCollider.get_overlapping_areas()
	if overlapping_bodies.size() > 0:
		can_drop_here = false
		$Sprite.modulate = Color(1, 0, 0)
	else:
		can_drop_here = true
		$Sprite.modulate = Color(1, 1, 1)

func updatePowerSource(powerSource, active):
	if active:
		if not powerSources.has(powerSource):
			powerSources.append(powerSource)
	else:
		if powerSources.has(powerSource):
			powerSources.remove(powerSources.find(powerSource))
	updatePowerState()

func updatePowerState():
	on = len(powerSources) > 0	# true if greater than 0
	set_texture()

func set_texture():
	if on:
		$PowerUp.play()
		$Sprite.texture = load("res://GFX/Simple Turret2.png")
	else:
		$PowerDown.play()
		$Sprite.texture = load("res://GFX/Simple Turret1.png")

func make_laser():
	if next_laser == null:
		var new_laser = laser_scene.instance()
#		new_laser.position = 
		root_node.add_child(new_laser)
		next_laser = new_laser
	next_laser.position = to_global($Laserstart.position)
	next_laser.rotation_degrees = rotation_degrees
	next_laser.originating_turret = self
	
#func make_laser():
#	if lasers_array.size() == 0:
#		var new_laser = laser_scene.instance()
#		new_laser.position = $Laserstart.position
#		new_laser.end_pos.y -= laser_distance
#		add_child(new_laser)
#		lasers_array.append(new_laser)
#	var space_state = get_world_2d().direct_space_state
#	var testpoint = Vector2()
#	if $RayCast2D.is_colliding():
##		print($RayCast2D.get_collider().to_string())
#		testpoint = transform.xform_inv($RayCast2D.get_collision_point())
#		var collision_normal = $RayCast2D.get_collision_normal()
##		print(collision_normal)
#		var reflected_angle = (testpoint - position).normalized().bounce(collision_normal)
#		print(reflected_angle)
#	else:
#		testpoint += $Laserstart.position
#		testpoint.y -= laser_distance
#	if debug_drawraycast:
#		$DebugLaser.set_point_position(0, $Laserstart.position)
#		$DebugLaser.set_point_position(1, testpoint)
#		$DebugLaser.visible = true
#	var result = space_state.intersect_ray($Laserstart.position, testpoint, [self])
#	print(result.size())
#	if result.collider != null:
#		print(result[0].collider.name)



func _input(event):
	if event is InputEventMouseMotion:
		var movement = event.get_relative()
		if rotating:
			movement.x *= rotate_speed
			rotation_degrees += movement.x
		elif dragging:
			if pickup_start_pos == null:
				pickup_start_pos = global_position
			global_position = root_node.get_global_mouse_position()
	elif event is InputEventMouseButton:
		if event.is_pressed():
			if mouse_in_drag:
				dragging = true
				$Pickup.play()
			elif mouse_in_rotate:
				rotating = true
		else:
			if !can_drop_here && pickup_start_pos != null:
				global_position = pickup_start_pos
			pickup_start_pos = null
			$Place.play()
			dragging = false
			rotating = false



func _on_PickupArea_mouse_entered():
	mouse_in_drag = true
	MouseManager.changeAnim("grabbing")
#	print("can drag")

func _on_PickupArea_mouse_exited():
	mouse_in_drag = false
	MouseManager.changeAnim("rotate")


func _on_RotateArea_mouse_entered():
	mouse_in_rotate = true
#	print("can rotate")
	MouseManager.changeAnim("rotate")


func _on_RotateArea_mouse_exited():
	mouse_in_rotate = false
	MouseManager.changeAnim(null)


func _on_TurretCollider_body_entered(body):
	print(body.name)
	pass # Replace with function body.


func _on_TurretCollider_area_entered(area):
	print(area.name)
	pass # Replace with function body.

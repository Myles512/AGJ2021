extends Node2D

#scene settings
export(PackedScene) var laser_scene
export var rotate_speed = 0.01
export var laser_distance = 500
export(bool) var on = true
var powerSources = []

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



func _input(event):
	if event is InputEventMouseMotion:
		var movement = event.get_relative()
		if rotating:
#			movement.x *= rotate_speed
#			rotation_degrees += movement.x
			look_at(root_node.get_local_mouse_position())
			rotate(PI / 2)
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

extends Node2D

#scene settings
export(PackedScene) var laser_scene
export var rotate_speed = 0.01
export var laser_distance = 100

#debug stuff
export var debug_drawraycast = false

var mouse_in_rotate = false
var mouse_in_drag = false
var dragging = false
var rotating = false



func _ready():
	pass



func _physics_process(delta):
	laser()



func laser():
	var space_state = get_world_2d().direct_space_state
	var testpoint = Vector2()
	testpoint += $Laserstart.position
	testpoint.y -= laser_distance
	if debug_drawraycast:
		$DebugLaser.set_point_position(0, $Laserstart.position)
		$DebugLaser.set_point_position(1, testpoint)
		$DebugLaser.visible = true
	var result = space_state.intersect_ray($Laserstart.position, testpoint, [self])
	#print(result.size())
#	if result.collider != null:
#		print(result[0].collider.name)



func _input(event):
	if event is InputEventMouseMotion:
		var movement = event.get_relative()
		if rotating:
			movement.x *= rotate_speed
			rotation_degrees += movement.x
		elif dragging:
			position += movement
	elif event is InputEventMouseButton:
		if event.is_pressed():
			if mouse_in_drag:
				dragging = true
			elif mouse_in_rotate:
				rotating = true
		else:
			dragging = false
			rotating = false



func _on_PickupArea_mouse_entered():
	mouse_in_drag = true
#	print("can drag")

func _on_PickupArea_mouse_exited():
	mouse_in_drag = false

func _on_RotateArea_mouse_entered():
	mouse_in_rotate = true
#	print("can rotate")

func _on_RotateArea_mouse_exited():
	mouse_in_rotate = false

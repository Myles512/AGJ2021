extends Node2D

export var rotate_speed = 0.01
var mouse_in_rotate = false
var mouse_in_drag = false
var dragging = false
var rotating = false
var next_laser = null
var can_drop_here = true
var pickup_start_pos = null

export(bool) var canBePickedUp = true
export(bool) var canBeRotated = true


var root_node



func _ready():
	root_node = get_tree().get_current_scene()


func _process(delta):
	if get_node("TurretCollider") != null:
		var overlapping_bodies = $TurretCollider.get_overlapping_areas()
		if overlapping_bodies.size() > 0:
			can_drop_here = false
			$Sprite.modulate = Color(1, 0, 0)
		else:
			can_drop_here = true
			$Sprite.modulate = Color(1, 1, 1)


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
			elif mouse_in_rotate:
				rotating = true
		else:
			if !can_drop_here && pickup_start_pos != null:
				global_position = pickup_start_pos
			pickup_start_pos = null
			dragging = false
			rotating = false

func _on_PickupArea_mouse_entered():
	if canBePickedUp:
		mouse_in_drag = true
		MouseManager.changeAnim("grabbing")
#	print("can drag")

func _on_PickupArea_mouse_exited():
	if canBePickedUp:
		mouse_in_drag = false
		if canBeRotated:
			MouseManager.changeAnim("rotate")
		else:
			MouseManager.changeAnim(null)


func _on_RotateArea_mouse_entered():
	if canBeRotated:
		mouse_in_rotate = true
		MouseManager.changeAnim("rotate")


func _on_RotateArea_mouse_exited():
	if canBeRotated:
		mouse_in_rotate = false
		MouseManager.changeAnim(null)

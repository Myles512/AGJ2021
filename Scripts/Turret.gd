extends Node2D

export var rotate_speed = 0.01

var mouse_in_rotate = false
var mouse_in_drag = false
var mouse_clicked = false
var dragging = false
var rotating = false

func _ready():
	pass

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

func _on_PickupArea_mouse_exited():
	mouse_in_drag = false

func _on_RotateArea_mouse_entered():
	mouse_in_rotate = true

func _on_RotateArea_mouse_exited():
	mouse_in_rotate = true

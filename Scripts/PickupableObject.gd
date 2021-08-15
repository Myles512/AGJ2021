extends Node2D

export var rotate_speed = 0.01
var mouse_in_rotate = false
var mouse_in_drag = false
var dragging = false
var rotating = false
var next_laser = null

export(bool) var canBePickedUp = true
export(bool) var canBeRotated = true


var root_node



func _ready():
	root_node = get_tree().get_current_scene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	if event is InputEventMouseMotion:
		var movement = event.get_relative()
		if rotating:
			movement.x *= rotate_speed
			rotation_degrees += movement.x
		elif dragging:
			#position += movement
			global_position = root_node.get_global_mouse_position()
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

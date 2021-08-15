extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			$AudioStreamPlayer.play()
			LevelTransition.transitionTo(false, "res://Scenes/LevelSelect.tscn")
		#var err = get_tree().change_scene("res://Scenes/LevelSelect.tscn")
		#if err:
		#	print("Scene change failed?")

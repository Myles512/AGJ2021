extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LightGoal_poweredOn():
	GameManager.markLevelAsCompleted()
	MouseManager.changeAnim(null)
	var err = get_tree().change_scene("res://Scenes/LevelSelect.tscn")
	if err:
		print(err, "error with scene change")

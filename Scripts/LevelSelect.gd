extends Node2D


var levelSelected = null


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in $"Tower Level Select".get_children():
		child.connect("levelSelected", self, "updateSelectedLevel")
		child.connect("startLevel", self, "startLevel")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func updateSelectedLevel(id):
	levelSelected = id
	print("level is now: " + str(levelSelected))


func startLevel():
	get_tree().change_scene("res://Scenes/Puzzles/Puzzle" + str(levelSelected) + ".tscn")

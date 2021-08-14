extends Node2D


export(int) var levelID
export(bool) var unlocked = false
var mouseInBox = false
signal levelSelected
signal startLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.visible = unlocked


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventMouseButton:
		if mouseInBox:
			emit_signal("startLevel")

func updatedLocked(locked):
	$Sprite.visible = !locked


func _on_Area2D_mouse_entered():
	mouseInBox = true
	if unlocked:
		emit_signal("levelSelected", levelID)


func _on_Area2D_mouse_exited():
	mouseInBox = false

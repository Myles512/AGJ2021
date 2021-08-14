extends Node2D


var on = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setOn(_on):
	on = _on
	if on:
		$Sprite.texture = load("res://GFX/Elec Bomb2.png")
	else:
		$Sprite.texture = load("res://GFX/Elec Bomb1.png")

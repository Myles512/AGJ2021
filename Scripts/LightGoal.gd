extends Node2D


var on = false
var timeOn = 0
signal poweredOn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on:
		timeOn += delta
	if timeOn > 1:
		emit_signal("poweredOn")

func setOn(_on):
	on = _on
	if on:
		$Sprite.texture = load("res://GFX/Light Goal2.png")
	else:
		$Sprite.texture = load("res://GFX/Light Goal1.png")

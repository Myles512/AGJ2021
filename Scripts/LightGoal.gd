extends Node2D


var on = false
var timeOn = 0
signal poweredOn
var powerSources = []
var mouse_pressed = false
var levelWon = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on and !mouse_pressed:
		timeOn += delta
	if timeOn > 1:
		if not levelWon:
			emit_signal("poweredOn")
			levelWon = true

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			mouse_pressed = true
		else:
			mouse_pressed = false


func updatePowerSource(powerSource, active):
	if active:
		if not powerSources.has(powerSource):
			powerSources.append(powerSource)
	else:
		if powerSources.has(powerSource):
			powerSources.remove(powerSources.find(powerSource))
	updatePowerState()

func updatePowerState():
	on = len(powerSources) > 0	# true if greater than 0
	if on:
		$Sprite.texture = load("res://GFX/Light Goal2.png")
	else:
		$Sprite.texture = load("res://GFX/Light Goal1.png")

extends "res://Scripts/PickupableObject.gd"


var on = false
var lastOn = false
var powerSources = []

# Called when the node enters the scene tree for the first time.
func _ready():
	updatePowerState()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func updatePowerSource(powerSource, active):
	if powerSource == $PowerField:
		return	# no point updating self
	if active:
		if not powerSources.has(powerSource):
			powerSources.append(powerSource)
	else:
		if powerSources.has(powerSource):
			powerSources.remove(powerSources.find(powerSource))
	updatePowerState()

func updatePowerState():
	on = len(powerSources) > 0	# true if greater than 0
	if lastOn != on:
		$PowerField.specialSetOn(on)
		if on:
			$Sprite.texture = load("res://GFX/Elec Bomb2.png")
		else:
			$Sprite.texture = load("res://GFX/Elec Bomb1.png")
	lastOn = on

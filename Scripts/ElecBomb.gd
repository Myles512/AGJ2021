extends "res://Scripts/PickupableObject.gd"


export(bool) var on = false
var lastOn = null
var powerSources = []
var power_up_sound_played = false
var power_down_sound_played = true

# Called when the node enters the scene tree for the first time.
func _ready():
	updatePowerState()

func _process(_delta):
	if on and !power_up_sound_played:
		$PowerUp.play()
		power_up_sound_played = true
		power_down_sound_played = false
	elif !on and !power_down_sound_played:
		$PowerDown.play()
		power_up_sound_played = false
		power_down_sound_played = true


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

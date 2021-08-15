extends "res://Scripts/PickupableObject.gd"


var on = false
var powerSources = []
var original_door_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	original_door_pos = $"3SegmentNonreflectiveWall".position
	updatePowerState()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
		var new_door_pos = original_door_pos
		new_door_pos.y += 1000
		$"3SegmentNonreflectiveWall".position = new_door_pos
		$Sprite.texture = load("res://GFX/Elec Bomb2.png")
	else:
		$"3SegmentNonreflectiveWall".position = original_door_pos
		$Sprite.texture = load("res://GFX/Elec Bomb1.png")

extends Node2D


export(bool) var on = false
var lastPlayedPowerSfx = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func specialSetOn(_on):
	on = _on
	#print(on)
	if on and lastPlayedPowerSfx != "up":
		#$Powerup.play()
#		print(lastPlayedPowerSfx)
		lastPlayedPowerSfx = "up"
	elif !on and lastPlayedPowerSfx != "down":
#		print(lastPlayedPowerSfx)
		#$Powerdown.play()
		lastPlayedPowerSfx = "down"
	else:
		pass
	$AnimatedSprite.visible = on
	$Area2D/CollisionShape2D.set_deferred("disabled", !on)


func _on_Area2D_area_entered(area):
	var obj = area.owner
	if obj.has_method("updatePowerSource"):
		obj.updatePowerSource(self, true)


func _on_Area2D_area_exited(area):
	var obj = area.owner
	if is_instance_valid(obj) and obj.has_method("updatePowerSource"):
		obj.updatePowerSource(self, false)


func _on_Area2D_body_entered(body):
	var obj = body.owner
	if obj.has_method("updatePowerSource"):
		obj.updatePowerSource(self, true)


func _on_Area2D_body_exited(body):
	var obj = body.owner
	if is_instance_valid(obj) and obj.has_method("updatePowerSource"):
		obj.updatePowerSource(self, false)

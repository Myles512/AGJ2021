extends Node2D


export(bool) var on = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func specialSetOn(_on):
	on = _on
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

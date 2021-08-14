extends Node2D


export(bool) var on = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func setOn(_on):
	on = _on
	$AnimatedSprite.visible = on
	$Area2D/CollisionShape2D.disabled = !on

func _on_Area2D_area_entered(area):
	var obj = area.owner
	if obj.has_method("setOn"):
		obj.setOn(true)


func _on_Area2D_area_exited(area):
	var obj = area.owner
	if obj.has_method("setOn"):
		obj.setOn(false)

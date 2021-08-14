extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	changeAnim(null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position()


#func changeState(newState):
#	mouseState

func changeAnim(newAnim):
	if newAnim:
		$AnimatedSprite.visible = true
		$AnimatedSprite.animation = newAnim
	else:
		$AnimatedSprite.visible = false

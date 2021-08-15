extends Control


var fadingIn = false
var levelToTransitionTo = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func transitionTo(fadeIn, _levelToTransitionTo):
	if fadeIn:
		$AnimationPlayer.play("TransitionFromBlack")
	else:
		$AnimationPlayer.play("TransitionToBlack")
		if _levelToTransitionTo:
			levelToTransitionTo = _levelToTransitionTo


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "TransitionToBlack":
		var err = get_tree().change_scene(levelToTransitionTo)
		if err:
			print(err, " occurred during transition")
		transitionTo(true, null)

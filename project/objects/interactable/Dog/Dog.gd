extends Interactable
class_name Dog

func _interact(player):
	
	#Play the happy dog animation
	$dog/AnimationPlayer.play("happy")
	yield($dog/AnimationPlayer, "animation_finished")
	$dog/AnimationPlayer.play("idle")

extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_IntroElements_start_game_pressed():
	$Tween.interpolate_property($Camera/Sprite3D, "opacity", 0, 1, 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	$Timer.start()
	


func _on_Timer_timeout():
	get_tree().change_scene("res://scene/main_scene.tscn")


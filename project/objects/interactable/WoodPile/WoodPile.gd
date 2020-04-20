extends Interactable
class_name WoodPile

var log_scene = preload("res://objects/interactable/Pickup/Wood/Stick.tscn")


func _interact(player):
	
	#Remove from the pile
	var log_node = $Logs.get_child(0)
	if log_node:
		log_node.queue_free()
		
		#Now tell the user to pick up a new one
		#Spawn a new wood object
		var new_log = log_scene.instance()
		
		#Give that log to the player
		player._pickup(new_log)
	else:
		self.active = false

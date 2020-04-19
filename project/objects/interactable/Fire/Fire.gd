extends Interactable
class_name Fire

func _ready():
	._ready()
	
	#Also add some more destination areas
	_add_destination($Destination)
	_add_destination($Destination2)
	_add_destination($Destination3)

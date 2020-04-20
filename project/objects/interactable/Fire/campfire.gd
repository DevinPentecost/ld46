extends MeshInstance

var decay_enabled = false
var decay = 2 # Units of fuel per second
var current_fuel = 100

func _ready():
	set_process(true)

func _process(delta):
	
	if decay_enabled:
		current_fuel -= delta * decay
		
	# Modify campfire things
	

func add_fuel():
	decay_enabled = true
	current_fuel += 100

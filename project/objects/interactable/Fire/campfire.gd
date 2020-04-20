extends MeshInstance

var decay_enabled = false
var decay = 2 # Units of fuel per second
var current_fuel = 100

signal fuel_ran_out

var fuels_out = false

func _ready():
	set_process(true)

func _process(delta):
	
	if decay_enabled:
		current_fuel -= delta * decay
		
		if current_fuel <= 0:
			current_fuel = 0
			if fuels_out == false:
				fuels_out = true
				emit_signal("fuel_ran_out")
		 
		
	# Modify campfire things
	$CrispyLogs.fire_brightness = current_fuel / 100 
	

func add_fuel():
	decay_enabled = true
	fuels_out = false
	current_fuel += 100

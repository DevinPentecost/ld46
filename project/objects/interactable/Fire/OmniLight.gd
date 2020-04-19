extends OmniLight
tool

onready var noise = OpenSimplexNoise.new()

onready var energyBase = 0.7
onready var rangeBase = 7.7

onready var energyRange = Vector2(self.energyBase - .1, self.energyBase + .1)
onready var rangeRange = Vector2(self.rangeBase - 0.5, self.rangeBase + 0.5)

var x_position = 0
var flicker_loop_time = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_process(true)
	

func _process(delta):
	
	#Flicker our light
	x_position += 100/flicker_loop_time  * delta
	
	#Set the energy
	var energyNormalOffset = noise.get_noise_2dv(Vector2(x_position, 0))
	var energyOffset = lerp(energyRange.x, energyRange.y, energyNormalOffset)
	self.light_energy = energyOffset
	
	#Set the energy
	var rangeNormalOffset = noise.get_noise_2dv(Vector2(x_position, 30))
	var rangeOffset = lerp(rangeRange.x, rangeRange.y, rangeNormalOffset)
	self.omni_range = rangeOffset

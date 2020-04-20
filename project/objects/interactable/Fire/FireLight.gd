extends OmniLight
tool

onready var noise = NoiseTexture.new()


onready var energyBase = 0.7
onready var rangeBase = 7.7

onready var energyRange = Vector2(energyBase - .1, energyBase + .1)
onready var rangeRange = Vector2(rangeBase - 0.5, rangeBase + 0.5)

var x_position = 0
var flicker_loop_time = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	
	noise.noise = OpenSimplexNoise.new()
	noise.width = 100
	noise.height = 30
	noise.seamless = true
	

func _process(delta):
	
	#Flicker our light
	x_position += 100/flicker_loop_time  * delta
	if x_position > 100:
		x_position -= 100
	
	#Set the energy
	var energyNormalOffset = noise.noise.get_noise_2dv(Vector2(x_position, 0))
	var energyOffset = lerp(energyRange.x, energyRange.y, energyNormalOffset)
	self.light_energy = energyOffset
	
	#Set the energy
	var rangeNormalOffset = noise.noise.get_noise_2dv(Vector2(x_position, 30))
	var rangeOffset = lerp(rangeRange.x, rangeRange.y, rangeNormalOffset)
	self.omni_range = rangeOffset
	
	pass

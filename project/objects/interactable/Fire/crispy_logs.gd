extends Spatial
tool

onready var noise = NoiseTexture.new()

export(Color) var fire_normal
export(Color) var fire_crispy
export(float, 0, 1) var fire_brightness = 1.0

var brightness_flicker_scale = 0.1 #10 percent flicker range from the brightness setpoint
var actual_brightness = fire_brightness

var noise_x_position = 0
var noise_speed_scale = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	
	noise.noise = OpenSimplexNoise.new()
	noise.noise.period = 2.0
	noise.noise.octaves = 4.0
	noise.noise.persistence = 0.6
	noise.width = 100
	noise.height = 30
	noise.seamless = true
	
	# Apply the shader mods to all the mesh's materials
	_update_shader_colors();
	_update_shader_brightness();
	_update_light_color();
	_begin_noise_speed_tween();
	

func _process(delta):
	noise_x_position += delta * noise_speed_scale * 10
	if noise_x_position > noise.width:
		noise_x_position -= noise.width
	
	actual_brightness = noise.noise.get_noise_2dv(Vector2(noise_x_position, 0)) * (-1)
	_update_light_color()
	_update_shader_brightness()

func _begin_noise_speed_tween():
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "noise_speed_scale", self.noise_speed_scale, randf(), randf())
	tween.start()
	yield(tween, "tween_completed")
	_begin_noise_speed_tween()

func _calcluate_actual_brightness():
	pass

func _update_light_color():
	var light = self.get_node("crispylight");
	light.light_color = fire_normal.linear_interpolate(fire_crispy, max(0, actual_brightness));

func _update_shader_colors():
	_apply_to_shaders("shader_param/color_base", fire_normal);
	_apply_to_shaders("shader_param/color_crispy", fire_crispy);

func _update_shader_brightness():
	_apply_to_shaders("shader_param/crispyness", actual_brightness);

func _apply_to_shaders(paramPath, paramVal):
	var logs = self.get_node("flamin")
	for matNum in range(logs.get_surface_material_count()):
		logs.get_surface_material(matNum).set(paramPath, paramVal);
	
	logs = self.get_node("flamin2")
	for matNum in range(logs.get_surface_material_count()):
		logs.get_surface_material(matNum).set(paramPath, paramVal);

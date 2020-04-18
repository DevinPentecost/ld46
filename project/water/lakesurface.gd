extends MeshInstance

onready var dummy_cam = $DummyCam
onready var mirror_cam = $Viewport/Camera

export(NodePath) var real_camera

var sploosh_location = Vector2(0.0, 3.0)
var sploosh_magnitude = 0.9
onready var decay_rate = 0.5 # 0.5 is an ok value
onready var decay = 0.0

# If you don't see a reflection when you run the scene,
# it's because the mesh instance, material, etc need to all
# be set as resource/local to scene = True.

func _ready():
	var display_width = ProjectSettings.get_setting("display/window/size/width")
	var display_height = ProjectSettings.get_setting("display/window/size/height")
	$Viewport.size = Vector2(display_width / 2, display_height / 2)
	
	# debug start sploosh
	sploosh(sploosh_location, sploosh_magnitude)

func sploosh(location_vec2, magnitude_float):
	if decay <= 0.5: # Rate limit splooshes
		decay = 1.0
		sploosh_location = location_vec2
		sploosh_magnitude = min(magnitude_float, 0.3)

func _process(delta):
	# Find the active / real camera
	var real_cam_node = null
	if real_camera.is_empty():
		real_cam_node = get_viewport().get_camera()
	else:
		real_cam_node = get_node(real_camera)
	
	# Do some tricky math to set the mirror cam in the correct
	# position so it is in the reflected camera position of the
	# real camera.
	scale.y *= -1
	dummy_cam.global_transform = real_cam_node.global_transform
	scale.y *= -1
	mirror_cam.global_transform = dummy_cam.global_transform
	mirror_cam.global_transform.basis.x *= -1
	
	# Fade out the sploosh
	decay = decay - delta * decay_rate
	if decay <= 0.01:
		decay = 0.0
	self.mesh.surface_get_material(0).set("shader_param/disturb_location", sploosh_location)
	self.mesh.surface_get_material(0).set("shader_param/disturb_magnitude", sploosh_magnitude * decay)
	

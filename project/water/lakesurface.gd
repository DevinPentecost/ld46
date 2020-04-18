tool
extends MeshInstance

onready var dummy_cam = $DummyCam
onready var mirror_cam = $Viewport/Camera

export(NodePath) var real_camera

func _ready():
	var display_width = ProjectSettings.get_setting("display/window/size/width")
	var display_height = ProjectSettings.get_setting("display/window/size/height")
	$Viewport.size = Vector2(display_width, display_height)

func _process(_delta):
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
	

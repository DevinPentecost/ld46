extends Spatial
class_name Interactable

var active = true
var hovered = false

func _ready():
	$HoverMesh.hide()

func _on_Area_mouse_entered():
	hovered = true
	if active:
		$HoverMesh.show()
	else:
		$HoverMesh.hide()

func _on_Area_mouse_exited():
	hovered = false
	$HoverMesh.hide()

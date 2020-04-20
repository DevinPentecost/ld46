extends Spatial
class_name Interactable

export(SpatialMaterial) var hover_material

var active = true
var hovered = false

func _ready():
	$HoverMesh.hide()
	
	#Did we get a material for the mesh?
	if hover_material:
		$HoverMesh.material_override = hover_material

func _interact():
	#Do something when interacted with
	pass

func get_best_location(starting_point : Vector3) -> Vector3:
	#Override this to get different 'hard points' to stand at
	return to_global(_get_best_destination(starting_point).transform.origin)

func _get_best_destination(starting_point : Vector3) -> Spatial:
	#Iterate over all the destinations
	var min_distance = 99999999999
	var min_destination = null
	for destination in $Destinations.get_children():
		#What is the distance?
		var distance = starting_point.distance_squared_to(destination.global_transform.origin)
		if distance < min_distance:
			min_distance = distance
			min_destination = destination
	return min_destination
	

func _add_destination(area : Area):
	#Re-parent
	area.get_parent().remove_child(area)
	$Destinations.add_child(area)

func has_destination(area : Area):
	#Check the destination area(s)
	for destination_area in $Destinations.get_children():
		if area == destination_area:
			return true
	return false

func _on_HoverArea_mouse_entered():
	hovered = true
	if active:
		$HoverMesh.show()
	else:
		$HoverMesh.hide()

func _on_HoverArea_mouse_exited():
	hovered = false
	$HoverMesh.hide()

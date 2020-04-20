extends Interactable
class_name Fire

const THROW_TIME = 0.25

func _ready():
	._ready()

func throw(node : Pickup):
	
	var node_position = node.global_transform.origin
	
	#Rotate the throw path to face the node
	$ThrowPath.transform = $ThrowPath.transform.looking_at(node_position, Vector3.UP)
	
	#Make the first point start where the node currently is
	$ThrowPath.curve.set_point_position(0, to_local(node_position))
	
	#Make a new path follower
	var follow = PathFollow.new()
	$ThrowPath.add_child(follow)
	follow.loop = false
	
	#Add the node as a child of the path
	node.get_parent().remove_child(node)
	follow.add_child(node)
	
	#Animate it throwing
	$Tween.interpolate_property(follow, "unit_offset", 0, 1, THROW_TIME, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	follow.queue_free()

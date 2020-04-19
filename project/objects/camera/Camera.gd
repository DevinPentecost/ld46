extends Camera

export(NodePath) var look_target

# Camera constants
const TURN_SPEED = 1 # Radians per second

onready var player : Player = get_tree().get_nodes_in_group("player")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Do we have something to look at?
	if look_target:
		look_target = get_node(look_target)
	
	set_process(true)
	set_process_input(true)

func _input(event):
	
	#Poll for left click input
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		
		#Grab the starting point for the click (at the camera itself)
		var from_point = project_ray_origin(event.position)
		
		#Ask navigation for the target
		var to_point = from_point + project_ray_normal(event.position) * 100
		to_point = player.navigation.get_closest_point_to_segment(from_point, to_point)
		
		# We don't know if we're grabbing something yet
		player.target_interactable = null
		
		# Check to see if we hit a game object
		# Check all interactables
		for interactable in get_tree().get_nodes_in_group("interactable"):
			#Is it hovered?
			if interactable.active and interactable.hovered:
				#This is the one we want to move to
				to_point = interactable.get_best_location(player.global_transform.origin)
				player.target_interactable = interactable
				break
		
		#Navigate to the target point
		player.walk_to_point(to_point)

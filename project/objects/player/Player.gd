extends Spatial


#Some player constants
const TURN_SPEED = 4 # Radians per second
const WALK_SPEED = 4 # Units per second

#Player variables
onready var previous_position : Vector3 = self.transform.origin
var walk_path = []

#Get relevant nodes
onready var navigation = get_tree().get_nodes_in_group("navigation")[0]


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)


func walk_to_point(point : Vector3):
	
	# Ask the navigation to get us a path to the point
	walk_path = navigation.get_navigation_path(transform.origin, point)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Is there anything left of the path?
	if walk_path.size() > 1:
		
		#Distance to walk
		var walk_distance = delta * WALK_SPEED
		
		#While we still have a distance left to walk...
		while walk_distance > 0 and walk_path.size() >= 2:
			
			#Where to start on this segment of the path
			var path_start = walk_path[walk_path.size()-1]
			var path_end = walk_path[walk_path.size()-2]
			
			#What is the distance of this segment
			var segment_length = path_start.distance_to(path_end)
			
			#Are we stepping so far we skip the segment?
			if segment_length <= walk_distance:
				#We need to shorten the walk distance and move to the next segment
				walk_path.pop_back()
				walk_distance -= segment_length
			else:
				#Move the starting point to be the end of the step
				walk_path[walk_path.size()-1] = path_start.linear_interpolate(path_end, walk_distance/segment_length)
				break;
			
		#Get the character's position on the path
		var new_position = walk_path.back()
		
		#Now rotate to face the desired direction
			
		#Get the new looking direction
		var look_direction = new_position - previous_position
		var rotation_transform = transform.looking_at(transform.origin + look_direction, Vector3.UP)
		
		#Rotate ourselves some amount across that
		var new_rotation = Quat(transform.basis).slerp(rotation_transform.basis, TURN_SPEED*delta)
		set_transform(Transform(new_rotation, new_position))
		
		#Save this position as the previous one
		previous_position = transform.origin
	
		if walk_path.size() < 2:
			walk_path.clear()

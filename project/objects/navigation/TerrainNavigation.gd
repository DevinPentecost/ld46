extends Navigation

# Player Walking Speed
const SPEED = 4.0

#Navigation Points
var navigation_begin = Vector3()
var navigation_end = Vector3()

#Line Drawing Material
var line_material = SpatialMaterial.new()

#Navigation Path
var path = []
export(bool) var draw_path = true


# Called when the node enters the scene tree for the first time.
func _ready():
	#Set up the material for the line
	line_material.flags_unshaded = true
	line_material.flags_use_point_size = true
	line_material.albedo_color = Color.antiquewhite

func get_navigation_path(from : Vector3, to : Vector3) -> Array:
	# Get the start point and end point on the navmesh
	var navigation_begin = get_closest_point(from)
	var navigation_end = get_closest_point(to)
	
	#Make the path
	var path = Array(get_simple_path(navigation_begin, navigation_end, true))
	path.invert()
	
	#Draw the path that we are navigating
	if draw_path:
		var line_draw = $ImmediateGeometry
		line_draw.set_material_override(line_material)
		line_draw.clear()
		
		#Begin drawing the line verticies
		line_draw.begin(Mesh.PRIMITIVE_POINTS)
		line_draw.add_vertex(navigation_begin)
		line_draw.add_vertex(navigation_end)
		line_draw.end()
		
		#Begin drawing the line itself
		line_draw.begin(Mesh.PRIMITIVE_LINES)
		
		#Go over each point in the path
		for point in path:
			#Add a vertex to the line
			line_draw.add_vertex(point)
		line_draw.end()
	
	return path


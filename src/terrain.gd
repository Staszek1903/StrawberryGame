@tool
extends MeshInstance3D

@export
var regen:bool = false:
	set(value):
		generate_mesh()
		
@export
var primitive_type:Mesh.PrimitiveType = Mesh.PRIMITIVE_TRIANGLES:
	set(value):
		primitive_type = value
		generate_mesh()
		
@export_dir
var terrain_data_folder:String = ""

@export
var size:Vector2i = Vector2(10,10)

var st: SurfaceTool = SurfaceTool.new()
var height_map:Image = Image.new()
var texture_map:Image = Image.new()
const height_map_file_name = "height_map.png"
const texture_map_file_name = "texture_map.png"

func generate_mesh():
	print("GENERATING")
	st.begin(primitive_type)
	for x in size.x:
		for y in size.y:
			var p:Color = height_map.get_pixel(x,y)
			st.add_vertex(Vector3(x,p.r,y))
			
	for i in size.x * (size.y-1):
		if i%size.x == size.x-1: continue
		st.add_index(i)
		st.add_index(i+size.x)
		st.add_index(i+1)
		st.add_index(i+1)
		st.add_index(i+size.x)
		st.add_index(i+size.x+1)
		
	mesh = st.commit()
	print("DONE REGENERATING")

func _ready():
	var dir = DirAccess.open(terrain_data_folder)
	if !dir.file_exists(height_map_file_name):
		height_map = Image.create(size.x,size.y, true, Image.FORMAT_RGBAF)
		height_map.save_png(terrain_data_folder+"/"+height_map_file_name)
	else:
		height_map = load(terrain_data_folder+"/"+height_map_file_name)
		height_map.get_size()
		
	generate_mesh()

func _process(delta):
	pass
	
func _get_configuration_warnings():
	var warnings = []
	if terrain_data_folder == "":
		warnings.append("Terrain data folder not set")
		
	return warnings
	
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		height_map.save_png(terrain_data_folder+"/"+height_map_file_name)
		print("SAVING HEIGHT MAP")

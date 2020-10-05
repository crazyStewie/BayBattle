extends Spatial
class_name HexMap

export var width : int = 256;
export var height : int = 256;

export var chunk_width : int = 64;
export var chunk_height : int = 64;

var tile_data : Array = Array();
var tile_mesh_data : Array = Array();

var tile_data_changed : bool = false;


func initialize_tile_data(tile : Tile):
	self.tile_data.resize(self.width)
	for i in range(0, self.width):
		self.tile_data[i] = Array()
		self.tile_data[i].resize(self.height);
		for j in range(0, self.height):
			self.tile_data[i][j] = tile;
	pass

func generate_mesh_data(chunk_x : int, chunk_y : int):
	#Stores the tile resources being used, to prevent the creation
	#of multiple multimeshes for the same tile. Other arrays share
	#the indices of the tile in this one
	var used_tiles : Array = Array()
	#Stores the number of instances in each multimesh
	var n_instances : PoolIntArray = PoolIntArray()
	#Stores the transforms for all instances in each multimesh
	var transforms : Array = Array()

	var start_x : int = chunk_x*chunk_width
	var end_x : int = min(start_x + chunk_width, width) as int

	var start_y : int = chunk_y*chunk_width
	var end_y : int = min(start_y + chunk_width, width) as int

	for i in range(start_x, end_x):
		for j in range(start_y, end_y):
			var id = used_tiles.find(self.tile_data[i][j])
			if id < 0:
				used_tiles.push_back(self.tile_data[i][j])
				n_instances.push_back(0)
				transforms.push_back(Array())
			n_instances[id] += 1;
			var tile_position = Vector3.ZERO
			tile_position.x = i*(0.75*Tile.TILE_WIDTH);
			tile_position.z = Tile.TILE_HEIGHT*(j + 0.5*(i%2))
			transforms[id].push_back(Transform.IDENTITY.translated(tile_position))
			
	print("world uses ", used_tiles.size(), " different tiles")
	for node in tile_mesh_data[chunk_x][chunk_y]:
		if node is Node:
			node.queue_free();
	for id in range(used_tiles.size()):
		var multimesh : MultiMesh = MultiMesh.new()
		multimesh.mesh = used_tiles[id].mesh
		multimesh.color_format = MultiMesh.COLOR_NONE
		multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_NONE
		multimesh.transform_format = MultiMesh.TRANSFORM_3D
		multimesh.instance_count = n_instances[id]
		for instance_id in range(transforms[id].size()):
			multimesh.set_instance_transform(instance_id, transforms[id][instance_id])
		var node = MultiMeshInstance.new()
		node.multimesh = multimesh
		self.tile_mesh_data[chunk_x][chunk_y].push_back(node)
		self.add_child(node)
		pass
	pass

func _ready():
	self.initialize_tile_data(load("res://content/core/tiles/forest.tres"))
	for i in range(ceil(width as float/chunk_width)):
		tile_mesh_data.push_back(Array())
		for j in range(ceil(height as float/chunk_height)):
			tile_mesh_data[i].push_back(Array())
			self.generate_mesh_data(i, j)


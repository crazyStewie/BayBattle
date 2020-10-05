extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tile : Tile setget set_tile
onready var mesh : MeshInstance = $"ViewportContainer/Viewport/MeshInstance"
func set_tile(value : Tile):
	tile = value;
	mesh.mesh = tile.mesh;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

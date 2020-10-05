extends Resource
class_name Tile

enum MovementLayer{
	DEEP_WATER = 1,
	SHALLOW_WATER = 2,
	GROUND = 4,
	LOW_ALTITUDE = 8,
	HIGH_ALTITUDE = 16,
}
const TILE_WIDTH = 2.0;
const TILE_HEIGHT = 2.0*cos(deg2rad(30));

export(Mesh) var mesh : Mesh = Mesh.new();
export(int, FLAGS,  "Deep water", "Shallow water", "Ground", "Low Altitude", "High Altitude") var layers_avaliable : int = 3;

func can_move_to(layer : int, to_direction : int) -> bool:
	return self.layers_avaliable & layer != 0;

func can_move_from(layer : int, from_direction : int) -> bool:
	return self.layers_avaliable & layer != 0;
	

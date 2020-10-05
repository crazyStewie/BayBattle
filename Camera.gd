extends Camera

onready var target_positon : Vector3 = self.translation
var speed : float = 12
var smoothness : float = 4;
var min_height : float = 4;
var max_height : float = 400;
var zoom_speed : float = 32;
var delta_move : Vector3 = Vector3.ZERO
func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		delta_move.y -= zoom_speed*(target_positon.y/min_height)
	if event.is_action_pressed("zoom_out"):
		delta_move.y += zoom_speed*(target_positon.y/min_height)


func _process(delta):	
	self.translation = self.translation.linear_interpolate(target_positon, smoothness*delta)

func _physics_process(delta):
	delta_move.x += speed*(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))*(target_positon.y/min_height)
	delta_move.z -= speed*(Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down"))*(target_positon.y/min_height)
	target_positon += delta_move*delta;
	target_positon.y = clamp(target_positon.y, min_height, max_height)
	delta_move = Vector3.ZERO

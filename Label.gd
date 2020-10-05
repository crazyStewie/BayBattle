extends Label

func _process(delta : float):
	if delta != 0.0:
		self.text = String(1.0/delta);

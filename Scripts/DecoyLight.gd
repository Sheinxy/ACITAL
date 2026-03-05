extends Light2D

var sense: int = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.enabled:
		self.energy += sense * 0.1
		self.color.h += 0.001
		if self.color.h >= 0.12:
			self.color.h = 0
		if self.energy >= 4 or self.energy <= 0:
			sense *= -1
	else:
		self.energy = 0

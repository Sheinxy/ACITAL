extends AudioStreamPlayer

export (float) var loop_offset = 12.80

# Called when the node enters the scene tree for the first time.
func _ready():
	self.stream.set_loop(true)
	self.stream.set_loop_offset(loop_offset)

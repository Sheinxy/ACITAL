extends YSort

func _ready():
	if has_node("/root/MusicPlayer"):
		if not get_node("/root/MusicPlayer").playing:
			get_node("/root/MusicPlayer").playing = true

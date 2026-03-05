extends Node2D

export (String) var on_finish = ""

func _ready():
	if has_node("/root/MusicPlayer"):
		get_node("/root/MusicPlayer").playing = false

func _change_scene():
# warning-ignore:return_value_discarded
	if not on_finish.empty():
		get_tree().change_scene(on_finish)

extends Area2D

export (String) var next_scene = "res://TestWorld.tscn"

func _player_on_stairs(_body):
# warning-ignore:return_value_discarded
	get_tree().change_scene(next_scene)

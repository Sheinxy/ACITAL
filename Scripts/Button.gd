extends StaticBody2D

const Door = preload("res://Scripts/Door.gd")
onready var DoorButton = get_script()

func press_button():
	for node in get_tree().current_scene.get_node("Doors").get_children():
		if node is Door:
			node.change_state()
	for node in get_parent().get_children():
		if node is DoorButton:
			node.change_state()


func change_state():
	$AnimatedSprite.playing = true
	$ButtonSound.play(0)
	$ButtonSound.playing = true


func _animation_finished():
	$AnimatedSprite.animation = ("Red" if $AnimatedSprite.animation == "Green"
								 else "Green")
	$AnimatedSprite.playing = false

extends KinematicBody2D

export(int) var speed = 200

const DoorButton = preload("res://Scripts/Button.gd")
const Decoy = preload("res://Scripts/Decoy.gd")
const DecoyObject = preload("res://Objects/Decoy.tscn")

onready var has_decoy: bool = true

var step_sound : bool = true

func _process(_delta):
	_move()
	_decoy()

func _move() -> void:
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var vertical_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
# warning-ignore:return_value_discarded
	move_and_slide(speed * Vector2(horizontal_input, vertical_input), Vector2.ZERO)
	
	$Sprite.flip_h = (horizontal_input > 0 or horizontal_input == 0 and $Sprite.flip_h)
	
	if horizontal_input == 0 and vertical_input == 0:
		$Sprite/AnimationPlayer.play("Idle")
		$SoundTimer.stop()
		$StepSound.playing = false
		step_sound = true
	else:
		_play_step()
		if vertical_input < 0:
			$Sprite/AnimationPlayer.play("Back")
		else:
			$Sprite/AnimationPlayer.play("Front")
	
func _play_step() -> void:
	if step_sound:
		step_sound = false
		$StepSound.play(0)
		$StepSound.playing = true
		$SoundTimer.start(0.5)
		
func _decoy() -> void:
	if Input.is_action_just_pressed("ui_select"):
		if has_decoy:
			var decoy: Decoy = DecoyObject.instance()
			get_tree().current_scene.add_child(decoy)
			decoy.position = self.position
			$DecoyTimer.start(0.1)
		else:
			var decoy: Decoy = get_tree().current_scene.get_node("Decoy")
			decoy.switch_state()

func _got_caught(_body):
	$HurtSound.play(0)
	$HurtSound.playing = true
	self.speed = 0
	

func _enter_area(area):
	if area.get_parent() is DoorButton:
		area.get_parent().press_button()
	elif area is Decoy and not has_decoy:
		area.free()
		has_decoy = true
		$PickupSound.play(0)
		$PickupSound.playing = true

func _decoy_deployed():
	has_decoy = false

func _respawn():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func _reactivate_step():
	step_sound = true

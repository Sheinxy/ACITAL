extends CanvasLayer

export (Array, String) var dialogs = []
export (float) var speed = 20.0

const Pause = preload("res://Scripts/Pause.gd")

signal on_finish

var wait_for_input : bool = false
var current_dialog = 0
var previous_value = -1

var pause : Pause = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene.has_node("Pause"):
		pause = get_tree().current_scene.get_node("Pause")
	if dialogs.size() <= 0:
		if pause != null:
			pause.dialog = false
		emit_signal("on_finish")
		self.queue_free()
	else:
		get_tree().paused = true
		$NextTween.interpolate_property($Next, "margin_left", $Next.margin_left - 1, $Next.margin_left + 1, 0.5, Tween.TRANS_BACK)
		$NextTween.start()
		
		_start_dialog()

func _start_dialog():
	previous_value = -1
	$Text.text = dialogs[current_dialog]
	$Tween.interpolate_property($Text, "visible_characters", 0, dialogs[current_dialog].length(), dialogs[current_dialog].length() / speed)
	$Tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if wait_for_input and Input.is_action_just_pressed("next_dialog"):
		wait_for_input = false
		current_dialog += 1
		if current_dialog >= dialogs.size():
			if pause != null:
				pause.dialog = false
			get_tree().paused = false
			
			emit_signal("on_finish")
			self.queue_free()
		else:
			$Text.visible_characters = 0
			_start_dialog()
	elif Input.is_action_just_pressed("next_dialog"):
		wait_for_input = true
		$Tween.stop_all()
		$Text.visible_characters = dialogs[current_dialog].length()
	$Next.visible = wait_for_input

func _line_over(_object, _key):
	wait_for_input = true

func _play_sound(_object, _key, _elapsed, value):
	if previous_value + 1 <= value and value < dialogs[current_dialog].length() - 5 and not dialogs[current_dialog][value].empty():
		previous_value = value
		$DialogSound.play(0)
		$DialogSound.playing = true

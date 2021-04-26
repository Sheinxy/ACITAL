extends CanvasLayer

var dialog : bool = true
var paused : bool = false


func _ready():
	$PauseScreen/Music/HSlider.value = _get_bus_percent("Music")
	$PauseScreen/Sounds/HSlider.value = _get_bus_percent("SoundEffects")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not dialog and Input.is_action_just_pressed("pause"):
		if paused:
			_unpause()
		else:
			_pause()


func _unpause():
	paused = false
	get_tree().paused = false
	$PauseScreen.visible = false
	
func _pause():
	paused = true
	get_tree().paused = true
	$PauseScreen.visible = true



func _changed_sound(value):
	_change_volume(value, "SoundEffects")


func _change_music(value):
	_change_volume(value, "Music")
	
func _change_volume(value: float, bus: String) -> void:
	if $PauseScreen.visible:
		var bus_index : int = AudioServer.get_bus_index(bus)
		if value == 0:
			AudioServer.set_bus_mute(bus_index, true)
		else:
			var log_of : float = log(value / 100.0) / log(10)
			var db : float = log_of * 80.0 / 2.0
			AudioServer.set_bus_mute(bus_index, false)
			AudioServer.set_bus_volume_db(bus_index, db)
			$SliderSound.volume_db = db
			$SliderSound.play(0)

func _get_bus_percent(bus: String) -> float:
	var bus_index : int = AudioServer.get_bus_index(bus)
	if AudioServer.is_bus_mute(bus_index):
		return 0.0
	var db : float = AudioServer.get_bus_volume_db(bus_index)
	return pow(10, db * 2.0 / 80) * 100.0

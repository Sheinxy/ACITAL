extends Area2D

export (bool) var active = false

func switch_state():
	active = not active
	
	if active:
		$Light2D.enabled = true
		$Light2D.color.h = 0
		$Light2D.sense = 1
		$Light2D.energy = 0
		$AnimatedSprite.play("Active")
		$DecoySound.play(0)
		$DecoySound.playing = true
	else:
		$Light2D.enabled = false
		$AnimatedSprite.play("Idle")


func _play_sound():
	if active:
		$DecoySound.play(0)
		$DecoySound.playing = true


func _restart_alarm_timer():
	$AlarmTimer.start(1)

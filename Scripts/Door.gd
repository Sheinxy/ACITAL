extends StaticBody2D

enum States {
	OpenedLeft,
	OpenedUp,
	ClosedLeft,
	ClosedUp
}

export (States) var state = States.ClosedUp

# Called when the node enters the scene tree for the first time.
func _ready():
	_apply_state()

func _apply_state() -> void:
	match state:
		States.OpenedLeft:
			$Sprite/AnimationPlayer.play("OpenedLeft")
		States.OpenedUp:
			$Sprite/AnimationPlayer.play("OpenedUp")
		States.ClosedLeft:
			$Sprite/AnimationPlayer.play("ClosedLeft")
		States.ClosedUp:
			$Sprite/AnimationPlayer.play("ClosedUp")

func _switch_state() -> void:
	match state:
		States.OpenedLeft:
			state = States.ClosedLeft
		States.OpenedUp:
			state = States.ClosedUp
		States.ClosedLeft:
			state = States.OpenedLeft
		States.ClosedUp:
			state = States.OpenedUp

func change_state() -> void:
	_switch_state()
	_apply_state()

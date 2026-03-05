extends KinematicBody2D

export (Array, Vector2) var path = []
export (int) var base_speed = 100
export (int) var current_node = -1
export (int) var reaction_time = 25

const DoorButton = preload("res://Scripts/Button.gd")
const Decoy = preload("res://Scripts/Decoy.gd")
const Player = preload("res://Scripts/Player.gd")
var player: Player = null

var path_visited : Array = []
var must_press : bool = true
var step_sound : bool = true
var attack_countdown : int = reaction_time

# Called when the node enters the scene tree for the first time.
func _ready():
	if path.size() > 0:
		current_node = current_node % path.size()
		for _i in range(path.size()):
			path_visited.append(false)
	player = get_tree().current_scene.get_node("Player")

func _reset_visited() -> void:
	for i in range(path.size()):
		path_visited[i] = false
		
func _all_visited() -> bool:
	for state in path_visited:
		if not state:
			return false
	return true 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _sees_player():
		current_node = -1
		if attack_countdown <= 0:
			$ExclamationMark.visible = false
			_follow_player()
		else:
			_notice()
	elif _sees_decoy():
		current_node = -1
		if attack_countdown <= reaction_time / 4:
			$ExclamationMark.visible = false
			_follow_decoy()
		else:
			_notice()
	else:
		$ExclamationMark.visible = false
		attack_countdown = reaction_time
		if must_press and _closest_button() != null:
			current_node = -1
			_follow_button()
		elif path.size() > 0:
			if current_node < 0:
				current_node = _find_best_node()
			if current_node >= 0:
				_follow_path()
		else:
			$Sprite/AnimationPlayer.play("Idle")
			
func _notice() -> void:
	$ExclamationMark.visible = true
	attack_countdown -= 1
	_play_noticed()
	$Sprite/AnimationPlayer.play("Idle")

func _play_noticed() -> void:
	if not $NoticedSound.playing:
		$NoticedSound.play(0)
		$NoticedSound.playing = true
		
func _sees_player() -> bool:
	if player == null:
		return false

	$RayCast2D.set_cast_to(player.position - self.position)
	$RayCast2D.force_raycast_update()
	return not $RayCast2D.is_colliding()
	
func _sees_decoy() -> bool:
	if not get_tree().current_scene.has_node("Decoy"):
		return false
	
	var decoy = get_tree().current_scene.get_node("Decoy")
	if decoy is Decoy:
		if not decoy.active:
			return false
		
		$RayCast2D.set_cast_to(decoy.position - self.position)
		$RayCast2D.force_raycast_update()
		return not $RayCast2D.is_colliding()
	return false
	
func _sees_node(node: Vector2) -> bool:
	$RayCast2D.set_cast_to(node - self.position)
	$RayCast2D.force_raycast_update()
	return not $RayCast2D.is_colliding()
	
func _sees_button(node: DoorButton) -> bool:
	$RayCast2D.set_cast_to(node.position - self.position)
	$RayCast2D.force_raycast_update()
	return not $RayCast2D.is_colliding()
	
func _closest_button() -> DoorButton:
	var closest: DoorButton = null
	for button in get_tree().current_scene.get_node("Buttons").get_children():
		if button is DoorButton:
			if _sees_button(button) and (closest == null or button.position.distance_squared_to(self.position) < closest.position.distance_squared_to(self.position)):
				closest = button
	return closest
	
func _find_best_node() -> int:
	var best : int = -1
	for i in range(path.size()):
		var node: Vector2 = path[i]
		if _sees_node(node):
			if best < 0:
				best = i
			elif path_visited[best] and not path_visited[i]:
				best = i
			elif path_visited[i] and not path_visited[best]:
				best = best
			elif path[best].distance_squared_to(self.position) < 8:
				best = i
			elif path[i].distance_squared_to(self.position) < 8:
				best = best
			elif path[best].distance_squared_to(self.position) > node.distance_squared_to(self.position):
				best = i
	return best

func _follow_path() -> void:
	var objective: Vector2 = path[current_node]
	if objective.distance_squared_to(self.position) < 8:
		path_visited[current_node] = true
		current_node = (current_node + 1) % path.size()
		if _all_visited():
			_reset_visited()
		if path_visited[current_node] or not _sees_node(path[current_node]):
			current_node = _find_best_node()
	elif not _sees_node(path[current_node]):
		current_node = _find_best_node()
	else:
		_move_towards(objective, base_speed)
	
func _follow_player() -> void:
	var objective: Vector2 = player.position
	if objective.distance_squared_to(self.position) >= 1:
		_move_towards(objective, base_speed * 3)
		
func _follow_decoy() -> void:
	var objective: Vector2 = get_tree().current_scene.get_node("Decoy").position
	if objective.distance_squared_to(self.position) >= 1:
		_move_towards(objective, base_speed * 3)
		
func _follow_button() -> void:
	var button: DoorButton = _closest_button()
	var objective: Vector2 = button.position
	if objective.distance_squared_to(self.position) >= 80:
		_move_towards(objective, base_speed)
	else:
		button.press_button()
		must_press = false
		if $ButtonTimer.is_stopped():
			$ButtonTimer.start()

func _move_towards(objective: Vector2, speed: int) -> void:
	var drive: Vector2 = (objective - self.position)
# warning-ignore:return_value_discarded
	move_and_slide(drive.normalized() * speed, Vector2.ZERO)
	$Sprite.flip_h = (drive.x > 0)
	if int(drive.y) < 0:
		$Sprite/AnimationPlayer.play("Back")
	else:
		$Sprite/AnimationPlayer.play("Front")
	
	if step_sound:
		$StepSound.play(0)
		$StepSound.playing = true
		$StepTimer.start(75.0 / speed)
		step_sound = false


func _want_to_press():
	must_press = true


func _activate_step():
	step_sound = true

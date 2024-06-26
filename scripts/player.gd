class_name Player extends CharacterBody2D

@onready var healthBar = $CanvasLayer/HealthBar
@onready var finish_level_scene = $CanvasLayer/FinishLevelScene
@onready var fail_level_scene = $CanvasLayer/FailLevelScene
@onready var score_label = $CanvasLayer/FinishLevelScene/MarginContainer/HBoxContainer/VBoxContainer/Score
@onready var time_label = $CanvasLayer/FinishLevelScene/MarginContainer/HBoxContainer/VBoxContainer/Time
@onready var time_counter = $CanvasLayer/TimeCounter
@onready var damage_taken = $CanvasLayer/DamageTaken
@onready var movement_sound = $MovementSound
@onready var progress_label = $CanvasLayer/Progress

var Speed_multiplier: float = 6
var Max_health: float = 100
var health: float = 100
enum Rank { D = 70, C = 80, B = 85, A = 90, S = 95, SS = 100 }
var currentRank: Rank = Rank.SS
var timeElapsed: float = 0
var time: int = 0
var totalDamageTaken: int = 0
var timeString : String
var score : String
var canMove
var speedRatio = 1.0
var push_force = 50.0
var finish_position = Vector2.ZERO

signal gameEndedSignal

func _ready():
	health = Max_health
	healthBar.init_health(health)
	updateRank()
	time_counter.text = "Time: "

func _physics_process(delta):
	if canMove:
		Speed_multiplier = lerp(2, 6, speedRatio)
		var targetDir: Vector2 = (get_global_mouse_position() - global_position)
		var targetVelocity: Vector2 = targetDir * Speed_multiplier
		velocity = velocity.lerp(targetVelocity, 0.5)
		move_and_slide()
		calculate_progress()
		
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if c.get_collider() is RigidBody2D:
				c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
		
		timeElapsed += delta
		updateTimeLabel()
		var linearGain = db_to_linear(1.0)
		var volumeGain = db_to_linear(1.0)
		linearGain *= clamp(velocity.length() / 256.0, 0.0, 14.0)
		volumeGain *= clamp(velocity.length() / 1024.0, 0.0, 0.75)
		var wind_bus_index = AudioServer.get_bus_index("Player")
		var volume_db = linear_to_db(volumeGain)
		var effect: AudioEffectEQ = AudioServer.get_bus_effect(AudioServer.get_bus_index("Player"), 0)
		AudioServer.set_bus_volume_db(wind_bus_index, volume_db)
		if effect:
			effect.set_band_gain_db(1, linearGain)
		if !movement_sound.playing:
			movement_sound.play()
	else:
		movement_sound.stop()

func updateTimeLabel():
	var totalSeconds: int = time + int(timeElapsed)
	var minutes: int = int(float(totalSeconds) / 60)
	var seconds: int = totalSeconds % 60
	
	timeString = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	time_counter.text = 'Time: ' + timeString
	time_label.text = 'Time: ' + timeString


func _input(event):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			if canMove:
				decrease_health(5)
		elif mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed:
			if canMove:
				increase_health(25)

func decrease_health(amount: int):
	health -= amount
	health = max(health, 0)
	totalDamageTaken += amount
	if healthBar != null:
		healthBar._set_health(health)
	if health == 0:
		_die()
	updateRank()

func increase_health(amount: int):
	health += amount
	health = min(health, Max_health)
	if healthBar != null:
		healthBar._set_health(health)
	if speedRatio < 1:
		speedRatio += 0.1
	updateRank()

func updateRank():
	var newRank: Rank = currentRank
	for rank in Rank.values():
		if health >= rank:
			newRank = rank
	if newRank < currentRank:
		currentRank = newRank
	score = get_rank_string(currentRank)
	score_label.text = "Damage Score: " + score + "\n" + str(totalDamageTaken) + " points of damage taken"
	damage_taken.text = "Damage Taken: " + str(totalDamageTaken)

func get_rank_string(rank: Rank) -> String:
	match rank:
		Rank.D: return "D"
		Rank.C: return "C"
		Rank.B: return "B"
		Rank.A: return "A"
		Rank.S: return "S"
		Rank.SS: return "SS"
	return ""

func _die():
	print('0 health!')
	level_failed()

func level_failed():
	emit_signal("gameEndedSignal")
	get_tree().paused = true
	fail_level_scene.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func level_finish():
	emit_signal("gameEndedSignal")
	get_tree().paused = true
	finish_level_scene.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	var current_scene = get_tree().get_current_scene()
	var level_name = current_scene.get_name()

	Global.save_scores.save_score_for_level(level_name, score, timeString)

func _on_area_2d_body_entered(_body):
	if canMove:
		if speedRatio >= 0.25:
			speedRatio -= 0.15

func pauseMovement():
	canMove = false

func resumeMovement():
	canMove = true

func find_finish_area(node: Node) -> Node:
	var level_pattern = "^(level|custom)\\d+$"
	var regex = RegEx.new()
	regex.compile(level_pattern)

	if regex.search(node.get_name()) != null:
		var finish_area = node.get_node("finish_area")
		if finish_area != null:
			return finish_area

	for child in node.get_children():
		var result = find_finish_area(child)
		if result != null:
			return result

	return null

func calculate_progress():
	var root_node = get_tree().get_root()
	var finish_area = find_finish_area(root_node)

	if finish_position == null || finish_area == null:
		return
		
	var player_position = global_position
	finish_position = finish_area.global_position
	
	var max_distance = Vector2.ZERO.distance_to(finish_position)
	var distance_to_finish = player_position.distance_to(finish_position)
	
	var progress_area_size = Vector2(465, 465)
	var progress_area_rect = Rect2(finish_position - progress_area_size / 2, progress_area_size)
	var is_inside_progress_area = progress_area_rect.has_point(player_position)
	
	var progress = 100.0 - (distance_to_finish / max_distance) * 100.0
	
	progress = clamp(progress, 0.0, 100.0)
	var formatted_progress = "%1.2f" % progress + "%"
	
	progress_label.text = formatted_progress
	
	if is_inside_progress_area:
		progress = 100
		progress_label.text = "100%"


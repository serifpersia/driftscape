class_name Player extends CharacterBody2D

@onready var healthBar = $CanvasLayer/HealthBar
@onready var finish_level_scene = $CanvasLayer/FinishLevelScene
@onready var fail_level_scene = $CanvasLayer/FailLevelScene
@onready var score_label = $CanvasLayer/FinishLevelScene/MarginContainer/HBoxContainer/VBoxContainer/Score
@onready var time_label = $CanvasLayer/FinishLevelScene/MarginContainer/HBoxContainer/VBoxContainer/Time
@onready var time_counter = $CanvasLayer/TimeCounter
@onready var damage_taken = $CanvasLayer/DamageTaken
@onready var movement_sound = $MovementSound

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

signal gameEndedSignal

func _ready():
	health = Max_health
	healthBar.init_health(health)
	updateRank()
	time_counter.text = "Time: "

func _physics_process(delta):
	if canMove:
		var healthRatio: float = health / Max_health
		var targetDir: Vector2 = (get_global_mouse_position() - global_position)
		var targetVelocity: Vector2 = targetDir * Speed_multiplier
		Speed_multiplier = lerp(2, 6, healthRatio)
		velocity = velocity.lerp(targetVelocity, 0.5)
		move_and_slide()
		timeElapsed += delta
		updateTimeLabel()
		var linearGain = db_to_linear(1.0)
		var volumeGain = db_to_linear(1.0)
		linearGain *= clamp(velocity.length() / 256.0, 0.0, 14.0)
		volumeGain *= clamp(velocity.length() / 1024.0, 0.0, 1.0)
		var wind_bus_index = AudioServer.get_bus_index("Wind")
		var volume_db = linear_to_db(volumeGain)
		var effect: AudioEffectEQ = AudioServer.get_bus_effect(AudioServer.get_bus_index("Wind"), 0)
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

	Global.save_data.save_score_for_level(level_name, score, timeString)

func _on_area_2d_body_entered(_body):
	if canMove:
		decrease_health(1)

func pauseMovement():
	canMove = false

func resumeMovement():
	canMove = true

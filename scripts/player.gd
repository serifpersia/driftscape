class_name Player extends CharacterBody2D

var Speed_multiplier: float = 6
var Max_health: float = 100
@onready var healthBar = $CanvasLayer/HealthBar
@onready var finish_level_scene = $CanvasLayer/FinishLevelScene
@onready var fail_level_scene = $CanvasLayer/FailLevelScene
@onready var score_label = $CanvasLayer/FinishLevelScene/MarginContainer/HBoxContainer/VBoxContainer/Score
@onready var time_label = $CanvasLayer/FinishLevelScene/MarginContainer/HBoxContainer/VBoxContainer/Time
@onready var time_counter = $CanvasLayer/TimeCounter
@onready var damage_taken = $CanvasLayer/DamageTaken

var health: float = 100
enum Rank { D = 70, C = 80, B = 85, A = 90, S = 95, SS = 100 }
var currentRank: Rank = Rank.SS
var timeElapsed: float = 0
var time: int = 0
var totalDamageTaken: int = 0

var saved_data: SaveData

var score : String
signal gameEndedSignal

func _ready():
	health = Max_health
	healthBar.init_health(health)
	updateRank()
	time_counter.text = "Time: "
	saved_data = SaveData.load_or_create()

func _physics_process(delta):
	var healthRatio: float = health / Max_health
	Speed_multiplier = lerp(2, 6, healthRatio)
	var targetDir: Vector2 = (get_global_mouse_position() - global_position)
	var targetVelocity: Vector2 = targetDir * Speed_multiplier
	velocity = velocity.lerp(targetVelocity, 0.5)
	move_and_slide()
	timeElapsed += delta
	updateTimeLabel()

func updateTimeLabel():
	var totalSeconds: int = time + int(timeElapsed)
	var minutes: int = int(float(totalSeconds) / 60)
	var seconds: int = totalSeconds % 60
	var timeString: String = "Time: " + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	time_counter.text = timeString
	time_label.text = timeString

func _input(event):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			decrease_health(5)
		elif mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed:
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
	
	 # Get the current scene's name as the level name
	var current_scene = get_tree().get_current_scene()
	var level_name = current_scene.get_name()
	
	# Call SaveData's function to save the score for the current level
	saved_data.save_score_for_level(level_name, score)

func _on_area_2d_body_entered(_body):
	decrease_health(1)

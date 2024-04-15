extends Node

@onready var startTimer = $StartTimer
@onready var countDownLabel = $"../CanvasLayer/Start"
@onready var player = $".."

@export var countdown = 2
var goDisplayed = false

func _ready():
	startTimer.start()
	player.pauseMovement()

func _on_start_timer_timeout():
	if countdown > 0:
		countDownLabel.text = str(countdown)
		countdown -= 1
	else:
		if not goDisplayed:
			countDownLabel.text = "GO!"
			goDisplayed = true
			player.resumeMovement()
		else:
			countDownLabel.queue_free()
			startTimer.stop()

func _on_countDownLabel_tree_exited():
	player.resumeMovement()
	
func _input(_event):
	if Input.is_action_just_pressed("skip"):
		countdown = 0

extends AudioStreamPlayer 

const BGM_JAZZY_MAIN_MENU = preload("res://sound/bgm_jazzy_main_menu.mp3")
const BGM_STAGE_1 = preload("res://sound/bgm_piano_pretty.mp3")
const BGM_STAGE_2 = preload("res://sound/bgm_stage_2.mp3")
const BGM_STAGE_3 = preload("res://sound/bgm_stage_3.mp3")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	stream = music
	volume_db = volume
	play()
	
func play_bgm_menu():
	_play_music(BGM_JAZZY_MAIN_MENU)

func play_bgm_stage1():
	_play_music(BGM_STAGE_1)

func play_bgm_stage2():
	_play_music(BGM_STAGE_2)
	
func play_bgm_stage3():
	_play_music(BGM_STAGE_3)

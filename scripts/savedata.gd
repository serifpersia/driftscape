class_name SaveData extends Resource

@export var level_scores = {}
@export var time_values = {}

const SAVE_PATH : String = "user://scores.tres"

func save() -> void:
	ResourceSaver.save(self, SAVE_PATH)

static func load_or_create() -> SaveData:
	var res: SaveData
	if FileAccess.file_exists(SAVE_PATH):
		res = load(SAVE_PATH) as SaveData
	else:
		res = SaveData.new()
	return res

func save_score_for_level(level_name: String, score_value: String, time_value: String) -> void:
	level_scores[level_name] = score_value
	time_values[level_name] = time_value
	save()

func get_level_score(level_name: String) -> String:
	if level_scores.has(level_name):
		return level_scores[level_name]
	else:
		return ""

func get_level_time(level_name: String) -> String:
	if time_values.has(level_name):
		return time_values[level_name]
	else:
		return ""

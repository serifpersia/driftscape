class_name SaveData extends Resource

@export var level_scores = {}

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

func save_score_for_level(level_name: String, score_value: String) -> void:
	level_scores[level_name] = score_value
	save()

func get_level_score(level_name: String) -> String:
	if level_scores.has(level_name):
		return level_scores[level_name]
	else:
		return ""

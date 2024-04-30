extends Node

var save_scores : SaveData
var save_options : SaveOptions

func _ready():
	save_scores = SaveData.load_or_create()
	save_options = SaveOptions.load_or_create()

	var defaults = save_options.get_defaults("Default")

	if defaults == 1:
		for bus_name in ["Master", "SFX", "BGM"]:
			var vol_db = get_default_db(bus_name)
			var vol_index = AudioServer.get_bus_index(bus_name)
			AudioServer.set_bus_volume_db(vol_index, vol_db)
	else:
		for bus_name in ["Master", "SFX", "BGM"]:
			var saved_vol = save_options.get_volume_value(bus_name)
			var vol_db = linear_to_db(saved_vol)
			var vol_index = AudioServer.get_bus_index(bus_name)
			AudioServer.set_bus_volume_db(vol_index, vol_db)

func get_default_db(bus_name):
	match bus_name:
		"Master":
			return linear_to_db(1.0)
		"SFX":
			return linear_to_db(0.5)
		"BGM":
			return linear_to_db(0.25)

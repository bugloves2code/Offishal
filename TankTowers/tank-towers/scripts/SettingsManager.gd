extends Node

var config = ConfigFile.new()
var settings_path = "user://settings.cfg"

# Default values
var settings = {
	"audio": {
		"master_volume": 100,
		"music_volume": 100,
		"sfx_volume": 100,
		"muted": false
	},
	"video": {
		"fullscreen": false
		}
	}

func _ready():
	load_settings()

func save_settings():
	for section in settings.keys():
		for key in settings[section]:
			config.set_value(section, key, settings[section][key])
	config.save(settings_path)
	
func load_settings():
	var err = config.load(settings_path)
	if err == OK:
		for section in settings.keys():
			for key in settings[section]:
				settings[section][key] = config.get_value(section, key, settings[section][key])
	apply_settings()
	
func apply_settings():
	# Audio settings
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), settings.audio.muted)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"), 
		linear_to_db(settings.audio.master_volume / 100)
	)
	
	# Music bus
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"), 
		linear_to_db(settings.audio.music_volume / 100)
	)

	# SFX bus
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"), 
		linear_to_db(settings.audio.sfx_volume / 100)
	)
	# Video settings
	get_window().mode = Window.MODE_FULLSCREEN if settings.video.fullscreen else Window.MODE_WINDOWED

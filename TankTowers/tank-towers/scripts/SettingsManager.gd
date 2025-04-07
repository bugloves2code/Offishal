## Fish Friends
## Last upadated 4/1/25 by Justin Ferreira
## SettingsManager Script
## Auto load that keeps Settings in one place
## really just for audio volume currently

extends Node

## config file for reference
var config = ConfigFile.new()
## path to reference file
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

# Loads on start
func _ready():
	# Gets saved settings
	load_settings()

## save_settings
## takes current settings and writes them into
## the file we have made for config
func save_settings():
	for section in settings.keys():
		for key in settings[section]:
			config.set_value(section, key, settings[section][key])
	config.save(settings_path)
	
## load_settings
## finds settings file and if it exist loads settings 
## which were saved if not then nothing happens
func load_settings():
	var err = config.load(settings_path)
	if err == OK:
		for section in settings.keys():
			for key in settings[section]:
				settings[section][key] = config.get_value(section, key, settings[section][key])
	apply_settings()
	
## apply_settings
## makes the settings that are either from the file
## or the user changing them what is actually being used
## by the system 
func apply_settings():
	# Mute master bus
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), settings.audio.muted)
	
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

## Fish Friends
## Last updated 3/2/25 by William Duprey
## Saving and Loading Script
## - This script handles saving and loading all data
##   required to play the game (tanks, fish, player stats, etc.)
## - Currently the save and load functions are connected to
##   temporary buttons in the Main scene, but I assume we'll
##   want to have some kind of autosave eventually, either
##   based on a Timer, or triggered whenever the player does
##   something worth saving.
## - Mostly followed this Godot tutorial:
##   https://www.youtube.com/watch?v=43BZsLZheA4

class_name SaverLoader
extends Node

## Saves data to a directory that is guaranteed to be writable.
## - Using res:// would not work, since when the project is
##   exported or compiled or whatever, that directory becomes read-only.
## - On Windows, the user:// directory points to this:
##   %APPDATA%\Godot\app_userdata\Tank Towers\
## Currently, the only thing saved is the player's money.
## - Incredibly rudimentary right now, very bad,
##   so many TODOs to be TODONE. This past week, I engaged 
##   in the time-honored tradition of procrastination, so 
##   this is all I have to show for now.
func SaveGame():
	var file = FileAccess.open("user://savegame.data", FileAccess.WRITE);
	
	# store_var saves the value in a binary format, so
	# the file itself is not human-readable
	file.store_var(PlayerManager.money);
	file.close();	

## Loads data from a file. 
## - Currently, the only thing loaded is the player's money.
func LoadGame():
	var file = FileAccess.open("user://savegame.data", FileAccess.READ)
	
	# Make sure the file exists first
	if(file == null):
		return;
	
	PlayerManager.money = file.get_var();
	file.close();

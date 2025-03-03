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

func SaveGame():
	var file = FileAccess.open("res://savegame.data", FileAccess.WRITE);
	file.store_var(PlayerManager.money);
	file.close();	


func LoadGame():
	var file = FileAccess.open("res://savegame.data", FileAccess.READ)
	PlayerManager.money = file.get_var();
	file.close();

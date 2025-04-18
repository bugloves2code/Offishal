## Fish Friends
## Last updated 3/23/25 by William Duprey
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

## This is sloppy, but works for now. If we ever
## have more than one type of fish, this will need
## to be changed. 
## - It's probably possible to save the resource path 
##   for a scene to a file, and to programmatically
##   create new instances from it later when loading.
const FishScene = preload("res://scenes/Fish.tscn")

## Saves data to a directory that is guaranteed to be writable.
## - Using res:// would not work, since when the project is
##   exported or compiled or whatever, that directory becomes read-only.
## - On Windows, the user:// directory points to this:
##   %APPDATA%\Godot\app_userdata\Tank Towers\
## - If the .tres file is dragged into the project and 
##   looked at in the inspector, all of the variables
##   exported in the SavedGame Resource will be visible.
## Currently, the only thing saved is the player's money.
## - Incredibly rudimentary right now, very bad,
##   so many TODOs to be TODONE. This past week, I engaged 
##   in the time-honored tradition of procrastination, so 
##   this is all I have to show for now.
func SaveGame():
	# Create a SavedGame object, and populate its 
	# exported variables with data we want to save
	var savedGame:SavedGame = SavedGame.new();
	
	# Initialize the fishList and plantList variables to empty arrays
	#savedGame.fishList = [];
	#savedGame.plantList = [];
	
	# Loop through each tank, and add data to SavedGame
	for tank:Tank in TankManager.tankList:		
		# Push an empty array for this tank's fish objects
		#savedGame.fishList.push_back([]);
		
		# Loop through the current tank's fish
		#for fish:Fish in tank.fishList:
			# Add the fish to the tank's corresponding array
			# - TODO: This is giving me some error about fish
			#   being null, and when debugging, it sure was.
			#   So, I'm not sure where the fish are actually
			#   being stored, since it doesn't seem to be inside
			#   the Tank's fishList.
			#savedGame.fishList[savedGame.tankCount].push_back(fish);
		
		# Repeat same process as above but for plants
		#savedGame.plantList.push_back([]);
		#for plant:Plant in tank.plantList:
		#	savedGame.fishList[savedGame.tankCount].push_back(plant);
		
		# Increment tank counter
		# - In GDScript, there is no ++ or --
		savedGame.tankCount += 1;
		
		# NOTE: Temporary, just store the number of fish
		savedGame.fishCounts.push_back(tank.fishList.size());
	
	savedGame.money = PlayerManager.money;
	
	# Save the data to a .tres (text-based resource) file
	# - This file will be human-readable
	# - If we want save files to not be human readable,
	#   the file type could be changed to .res
	ResourceSaver.save(savedGame, "user://savegame.tres");

## Loads data from a file. 
## - Clears out the current scene tree so that nodes are not
##   duplicated when loading new nodes from the file
func LoadGame():
	# "as" statement necessary for whatever 
	# Godot's version of Intellisense to work
	var savedGame:SavedGame = load("user://savegame.tres") as SavedGame;
	
	# Load the player's money.
	PlayerManager.money = savedGame.money;
	
	# Loop through existing tanks and clean them up
	# in preparation for loading new ones
	# - queue_free() is technically enough to delete, but
	#   just calling queue_free means the node will stay
	#   in the tree until the end of the frame, which
	#   can have unwanted side effects, so it's best
	#   practice to remove the node from its parent first
	for tank:Tank in TankManager.tankList:
		# Clear out all fish nodes too
		# - Or not necessary, since fish are children of tank?
		#   Garbage collector goes vroom?
		#for fish:Fish in tank.fishList:
		#	fish.get_parent().remove_child(fish);
		#	fish.queue_free();
		
		tank.get_parent().remove_child(tank);
		tank.queue_free();
		
	TankManager.tankList.clear();
	
	# Get the Tank UI node so that its tank creation function can be used
	var tankUINode:CanvasLayer = get_tree().current_scene.get_node("Tank UI - CanvasLayer");
	
	# Variable for the current tank being loaded in
	var tank:Tank;
	
	# Loop to load tanks
	# - This does play the sound effect for each tank created,
	#   but that can probably be fixed by just passing a boolean
	#   in as an argument to _on_create_tank_button_pressed, or something
	for i in savedGame.tankCount:
		# Create a tank object
		tankUINode._on_create_tank_button_pressed();
		
		# Find that tank object in the list of tanks
		tank = TankManager.tankList[i];
		
		# Create fish instances according to the stored count
		for j in savedGame.fishCounts[i]:
			# TODO: After saving other aspects of the current
			#       fish, this is where they would be applied,
			#       before adding it to the tank
			tank.AddFish(FishScene.instantiate());

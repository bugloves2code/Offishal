## Fish Friends
## Last updated 4/24/25 by William Duprey
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

## An array of packed scenes used to map fish species 
## to their corresponding packed scenes
## - Originally this was a dictionary, but enums as
##   keys were giving me some trouble, so now I just
##   use enums as indices into this array
## - This is worse than a dictionary, since these need
##   to be in the exact order as the enum, which is dumb.
##   But oh well. What are you gonna do?
var fishPathDict = [
	preload("res://scenes/Fish.tscn"),
	preload("res://scenes/ClownFish.tscn"),
	preload("res://scenes/BlueTang.tscn"),
	preload("res://scenes/Pike.tscn")
];

## An array that maps plant species to their packed scenes.
var plantPathDict = [
	preload("res://scenes/Plant.tscn"),
	preload("res://scenes/Anemone.tscn"),
	preload("res://scenes/Coral.tscn")
];

## Saves data to a directory that is guaranteed to be writable.
## - Using res:// would not work, since when the project is
##   exported or compiled or whatever, that directory becomes read-only.
## - On Windows, the user:// directory points to this:
##   %APPDATA%\Godot\app_userdata\Tank Towers\
## - If the .tres file is dragged into the project and 
##   looked at in the inspector, all of the variables
##   exported in the SavedGame Resource will be visible.
func SaveGame() -> void:
	# Create a SavedGame object, and populate its 
	# exported variables with data we want to save
	var savedGame:SavedGame = SavedGame.new();
	
	# Set simple data
	savedGame.money = PlayerManager.money;
	savedGame.level = PlayerManager.level;
	savedGame.xp = PlayerManager.xp;
	
	# Initialize the savedGame arrays to empty
	savedGame.tanks = [];
	savedGame.workers = [];
	savedGame.inventory = [];
	
	# Loop through each tank, and add data to SavedGame
	for tank:Tank in TankManager.tankList:		
		# Create a SavedTank object to store the data in each tank
		var savedTank = SavedTank.new();
		
		# Store simple tank data
		savedTank.name = tank.tankName;
		savedTank.waterType = tank.tank_type;
		
		# Initialize empty arrays for fish and plants,
		# then loop through the tank's fish and plants,
		# creating a SavedMarineLife object for each
		savedTank.fish = [];
		savedTank.plants = [];
		
		# Loop through all of the tank's fish, and create a 
		# SavedMarineLife Resource for each
		for fish: Fish in tank.fishList:
			# Store the savedMarineLife for the current fish
			# using a helper method to avoid repeating code
			savedTank.fish.push_back(SaveMarineLife(fish, true));
		
		# Repeat the near-identical process for plants
		for plant: Plant in tank.plantList:
			savedTank.plants.push_back(SaveMarineLife(plant, false));
		
		# Add the tank's data to the SavedGame's array of tanks
		savedGame.tanks.push_back(savedTank);
	
	# Save the player's inventory
	for marineLife: MarineLife in PlayerManager.marineLifeInventory:
		savedGame.inventory.push_back(
			SaveMarineLife(marineLife, marineLife is Fish));
	
	# Loop through the PlayerManager's Worker array to save them
	for worker: Worker in PlayerManager.workers:
		var savedWorker: SavedWorker = SavedWorker.new();
		
		# Save worker data to the Resource node
		savedWorker.level = worker.level;
		savedWorker.marineLifeHarvested = worker.harvestedMarineLife;
		
		# Store the savedWorker in the savedGame array
		savedGame.workers.push_back(savedWorker);
	
	# Save PlayerManager boolean variables
	savedGame.tutorialComplete = PlayerManager.tutorialComplete;
	savedGame.unlockNursery = PlayerManager.unlockNursery;
	savedGame.unlockTankUpgrade = PlayerManager.unlockTankUpgrade;
	savedGame.unlockAutoSell = PlayerManager.unlockAutoSell;
	savedGame.unlockFertilizer = PlayerManager.unlockFertilizer;
	savedGame.unlockSellAll = UiManager.PlayerUI.get_node("SellPanel/SellAllButton").visible;
	
	# Save the data to a .tres (text-based resource) file
	# - This file will be human-readable
	# - If we want save files to not be human readable,
	#   the file type could be changed to .res
	ResourceSaver.save(savedGame, "user://savegame.tres");


## A helper function to simplify saving fish and plant data
## - marineLife is a vile, untyped variable, which can be
##   either a fish or a plant.
## - Returns a SavedMarineLife Resource filled out with the
##   given marineLife object's data.
func SaveMarineLife(marineLife, isFish: bool) -> SavedMarineLife:
	# Create a SavedMarineLife Resource to fill out
	var savedMarineLife: SavedMarineLife = SavedMarineLife.new();
	
	# Use the dictionary defined above to store 
	# the fish's scene path based on its species
	savedMarineLife.species = marineLife.Species;
	
	# Only save fish name if the marine life is a fish
	if(isFish):
		savedMarineLife.name = marineLife.fishname;
	
	# Save whether the marine life is a fish
	savedMarineLife.isFish = isFish;
	
	# Save whether the fish is ready to be harvested
	var harvestTimer: Timer = marineLife.get_node("Harvest") as Timer;
	savedMarineLife.harvestReady = harvestTimer.time_left <= 0;
	
	return savedMarineLife;


## Loads data from a file. 
## - Clears out the current scene tree so that nodes are not
##   duplicated when loading new nodes from the file
## - Makes use of the existing functionality for creating
##   tanks inside the TankCreationUI script
func LoadGame() -> void:
	# "as" statement necessary for whatever 
	# Godot's version of Intellisense to work
	var savedGame:SavedGame = load("user://savegame.tres") as SavedGame;
	
	# --- Reset the game ---
	PlayerManager.level = 1;
	
	# Free up all the marine life and workers in the PlayerManager
	for marineLife: MarineLife in PlayerManager.marineLifeInventory:
		marineLife.queue_free();
	for worker: Worker in PlayerManager.workers:
		worker.queue_free();
	
	PlayerManager.marineLifeInventory.clear();
	PlayerManager.workers.clear();
	PlayerManager.unlocks.clear();
	PlayerManager.currentTankPrice = 0;
	
	# Reset unlock statuses
	PlayerManager.tutorialComplete = false;
	PlayerManager.unlockNursery = false;
	PlayerManager.unlockTankUpgrade = false;
	PlayerManager.unlockAutoSell = false;
	PlayerManager.unlockFertilizer = false;
	UiManager.PlayerUI.get_node("SellPanel/SellAllButton").visible = false;
	
	# This is dumb and bad, but I think it should work
	# for resetting the shop stock.
	# - The reason I'm even doing this is to prevent
	#   issues from happening when reloading data
	#   again, which shouldn't ever happen in the
	#   finished game (since data will be loaded once
	#   when the game starts).
	while UiManager.PlayerUI.ShopStock.size() > 1:
		UiManager.PlayerUI.ShopStock.pop_back();
	while UiManager.PlayerUI.PlantShopStock.size() > 1:
		UiManager.PlayerUI.PlantShopStock.pop_back();
	
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
	
	# --- Load in saved data ---
	# Get the Tank UI node so that its tank creation function can be used
	var tankUINode:CanvasLayer = get_tree().current_scene.get_node("TankCreationUI");
	
	# Load PlayerManager boolean variables
	# - Do this first, so that the tank capacity is properly upgraded
	PlayerManager.tutorialComplete = savedGame.tutorialComplete;
	PlayerManager.unlockNursery = savedGame.unlockNursery;
	PlayerManager.unlockTankUpgrade = savedGame.unlockTankUpgrade;
	PlayerManager.unlockAutoSell = savedGame.unlockAutoSell;
	PlayerManager.unlockFertilizer = savedGame.unlockFertilizer;
	UiManager.PlayerUI.get_node("SellPanel/SellAllButton").visible = savedGame.unlockSellAll;
	PlayerManager.checkUnlocks();	
	
	# Variables for the current tank being loaded in
	var tank:Tank;
	var savedTank:SavedTank;
	
	# Loop to load tanks
	for i in savedGame.tanks.size():
		# Grab the saved tank data
		savedTank = savedGame.tanks[i];
		
		# Here's a bunch of hacky setup that needs to happen
		# to be able to use the existing CreateTank functionality
		# - Set the TankCreationUI's freshwater and saltwater
		#   fields to something other than null
		# - Set the PlayerManager's currentTankPrice to something
		#   (in this case, just 0, which should always work)
		# - Set the PlayerManager's money to something higher than
		#   the tank price (though this could be 0, since it's
		#   a greater than or equal to check.
		tankUINode._update_tank_type(
			savedTank.waterType == ThEnums.WaterType.Fresh,
			savedTank.waterType == ThEnums.WaterType.Salt
		);
		PlayerManager.currentTankPrice = 0;
		PlayerManager.money = 100;
		
		# Create a tank object
		tankUINode.CreateTank();
		
		# Get the newly created tank from the TankManager's list of tanks
		tank = TankManager.tankList[i];
		
		# Load simple tank data
		tank.tank_type = savedTank.waterType;
		tank.tankName = savedTank.name;
		
		# The actual UI label needs to be updated
		tank.get_node("TankLabel").text = savedTank.name;
		
		# Loop to create fish in the current tank
		for savedFish: SavedMarineLife in savedTank.fish:
			#var fish: Fish = fishPathDict[savedFish.species].instantiate();
			var scene = fishPathDict[savedFish.species];
			var fish: Fish = scene.instantiate();
			
			# Set name (not sure if this actually works)
			fish.fishname = savedFish.name;
			
			# If the fish was ready to be harvested, then toggle
			# its harvestability using the _on_harvest_timout function
			if(savedFish.harvestReady):
				fish._on_harvest_timeout();
			
			tank.AddFish(fish);
		
		# Loop to create plants in the current tank
		# - Essentially the same as creating fish
		for savedPlant: SavedMarineLife in savedTank.plants:
			var plant: Plant = plantPathDict[savedPlant.species].instantiate();
			
			# Toggle harvestability
			if(savedPlant.harvestReady):
				plant._on_harvest_timeout();
				
			tank.AddPlant(plant);
	
	# Set the player's money ridiculously high to get around
	# the worker creation and upgrade functions reducing money
	PlayerManager.money = 100000;
	
	# Loop through the saved worker data and create new workers
	for i: int in savedGame.workers.size():
		var savedWorker: SavedWorker = savedGame.workers[i];
		
		# Call the worker creation function,
		# and get it from the workers array
		UiManager.PlayerUI._on_worker_upgrade_purchase();
		var worker: Worker = PlayerManager.workers[i];
		
		# Set simple data
		worker.harvestedMarineLife = savedWorker.marineLifeHarvested;
		
		# Upgrade the worker as many times as the level
		# - This should definitely be a different function to
		#   just set the level instead of calling LevelUp repeatedly
		# - Go one less than the level, since workers begin at level 1.
		for j: int in savedWorker.level - 1:
			worker.upgradeWorker();
	
	# Load the player's stats after creating all of the tanks, 
	# due to some wonky number stuff happening from 
	# reusing the existing tank creation functions
	PlayerManager.money = savedGame.money;
	if savedGame.tutorialComplete:
		UiManager.DontShowPlantYet = false;
	PlayerManager.SetLevel(savedGame.level);
	UiManager.PlayerUI.ShowPlayerLevel();
	PlayerManager.xp = savedGame.xp;
	
	# Load the player's inventory
	# - This is potentially the slowest part of the whole process,
	#   depending on how many things the player has saved.
	# - With more time, it would be very good to refactor to use
	#   a dictionary instead of an array, so that item totals could
	#   be stored instead of each full MarineLife node.
	for savedMarineLife: SavedMarineLife in savedGame.inventory:
		# If a fish, use the fishPathDict
		if(savedMarineLife.isFish):
			PlayerManager.marineLifeInventory.push_back(
				fishPathDict[savedMarineLife.species].instantiate());
		# Otherwise, use the plant
		else:
			PlayerManager.marineLifeInventory.push_back(
				plantPathDict[savedMarineLife.species].instantiate());
	
	# Make stuff visible if the player has completed the tutorial
	if PlayerManager.tutorialComplete:
		UiManager.PlayerUI.get_node("SellPanel").visible = true;
		UiManager.PlayerUI.get_node("Panel").visible = true;
		UiManager.PlayerUI.get_node("Panel/Menu").visible = true;
		UiManager.PlayerUI.get_node("Panel/Shop").visible = true;
		UiManager.PlayerUI.get_node("Panel/Upgrades").visible = true;
		UiManager.PlayerUI.get_node("Panel/Inventory").visible = true;
		
		# A truly insane line of code, but we do what we do
		get_tree().current_scene.get_node("Control/ScrollContainer/VBoxContainer/Control/CreateTankButton").visible = true;
	
	UiManager.ReloadAllUI();

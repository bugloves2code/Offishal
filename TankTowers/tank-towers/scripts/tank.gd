## Fish Friends
## Last upadated 4/1/25 by Justin Ferreira
## Tank Script
## - This scrpt decribes the tank scene 
## the tank will hold fish and plants
## The tank is a where fish and plant harvest
## collection pop up will happen and mantaince stats
## will be presented 

extends Control
class_name Tank


## tank_type is where this tanks WaterType will be stored
## this is currently hardcoded and shown in inspector
## this will likely be chosen before tank creation
@export var tank_type: ThEnums.WaterType

## fishCapacity is the amount of fish allowed in this tank
var fishCapacity = 10

## plantCapacity is the amount of plants allowed in this tank
var plantCapacity = 10

## fishList is an array which holds what fish are in the tank
var fishList: Array = []

## plantList is an array which holds what plants are in the tank
var plantList: Array = []

## tankName is the name of the tank
var tankName: String = "Awesome Tank"

signal addFish

## AddFish 
## This method checks if ther is room in the tank to add a fish
## if there are then it will add the given fish to fishList
func AddFish(fishInstance):
	# DELETES FISHINSTANCE BECAUSE SPAWNER 
	# NOT SET UP TO SPAWN ALREADY EXISTING FISH
	# AND KEEPING THIS FISH WILL CAUSE MEMORY LEAKS i think
	fishInstance.queue_free()
	
	if fishList.size() < fishCapacity:
		var fishspawned = SpawnManager.SpawnFish(self, fishInstance)
		if fishspawned.fishname == "":
			fishspawned.fishname = get_random_fish_name()
		fishList.append(fishspawned)
		self.add_child(fishspawned)
		$Bloop.play()
		## emit signal for adding fish	
		emit_signal("addFish")
		## print("Added Fish: " + fishInstance)
		## print("Added Fish: ", fishInstance)
		## print("Tank: ",tankName, " Fish Count: ", fishList.size())
	#else:
		## this needs to be a print statement
		## it should be a ui statment
		#print("Tank is full of fish")
	UiManager.ReloadAllUI()
	if PlayerManager.marineLifeInventory.size() == 0:
		UiManager.ShowInventory()
		

		
## AddPlant
## This method checks if ther is room in the tank to add a plant
## if there are then it will add the given plant to plantList
func AddPlant(plantInstance):	
	
	plantInstance.queue_free()
	
	
	
	if plantList.size() < plantCapacity:
		var plantSpawned = SpawnManager.SpawnPlant(self, plantInstance)
		plantList.append(plantSpawned)
		$Bloop.play()
		
	UiManager.ReloadAllUI()
	if PlayerManager.marineLifeInventory.size() == 0:
		UiManager.ShowInventory()

## _can_drop_data
## checks to seee if data is acceptable to be dropped here
## also if tank has room for it
func _can_drop_data(_pos,data):
	if data is Fish && fishList.size() >= fishCapacity:
		Notifier.push_notification("TANK IS FULL OF FISH")
	if data is Plant && plantList.size() >= plantCapacity:
		Notifier.push_notification("TANK IS FULL OF PLANTS")
	
	
	if data.waterType != ThEnums.WaterType.Fresh && self.tank_type == ThEnums.WaterType.Fresh:
		Notifier.push_notification("CANNOT PLACE MARINE LIFE OF DIFFERENT WATER TYPE")
		return false
	
	elif data.waterType != ThEnums.WaterType.Salt && self.tank_type == ThEnums.WaterType.Salt:
		Notifier.push_notification("CANNOT PLACE MARINE LIFE OF DIFFERENT WATER TYPE")
		return false
	
	if data is Node:
		if data is Fish && fishList.size() < fishCapacity:
			return true
		elif data is Plant && plantList.size() < plantCapacity:
			return true
	else:
		
		return false

## _drop_data
## checks if data dropped is a Fish or plant that can be
## added to the tank
func _drop_data(_pos, data):
	if data is Node:
		
		if data is Fish && !(fishList.size() >= fishCapacity):
			AddFish(data)
		elif data is Plant && !(plantList.size() >= plantCapacity):
			AddPlant(data)
		
		PlayerManager.marineLifeInventory.erase(data)
		if PlayerManager.marineLifeInventory.size() == 0:
			UiManager.ShowInventory()
			
		
		var Main = get_tree().current_scene
		var dragDrop = Main.get_node("DragDropMenu")
		if dragDrop and dragDrop.has_method("populate_hbox_container"):
			dragDrop.populate_hbox_container()
		
		data.queue_free()

## get_random_fish_name
## gives fish a random name
func get_random_fish_name() -> String:
	var fish_names = [
		# Species-inspired
		"Bubbles the Betta",
		"Finley the Flounder",
		"Goldie the Goldfish",
		"Stripes the Clownfish",
		"Sunny the Angelfish",
		"Sparky the Tetra",
		"Gillbert the Grouper",
		"Pearl the Parrotfish",
		"Sapphire the Tang",
		"Marlin the Moorish Idol",

		# Punny names
		"Fin Diesel",
		"Swim Shady",
		"Gill Clinton",
		"Anchovy Hopkins",
		"Cod Stewart",
		"Tuna Turner",
		"Salmon Rushdie",
		"Koi Pondsmith",
		"Sir Swims-a-Lot",
		"Bass Pro",

		# Whimsical/creative
		"Azure Waveglider",
		"Coral Dancer",
		"Sapphire Finflicker",
		"Moonlight Drifter",
		"Seafoam Sparkle",
		"Neptune's Whisper",
		"Abyssal Glimmer",
		"Tidal Twirler",
		"Poseidon's Prize",
		"Nimble Nibbler",

		# Simple/popular
		"Nemo",
		"Dory",
		"Bubbles",
		"Sushi",
		"Flash",
		"Splash",
		"Finley",
		"Waverly",
		"Azure",
		"Coral"
	]

	# Randomly select a name from the list
	var random_index = randi() % fish_names.size()
	return fish_names[random_index]

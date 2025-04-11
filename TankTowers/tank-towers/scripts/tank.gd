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

## WaterType is pulling the enum of WaterType from ThEnums.gd
## unsure if there is a better way of doing this because ThEmnums.gd
## is an Autoload 
const WaterType = preload("res://scripts/ThEnums.gd").WaterType

## tank_type is where this tanks WaterType will be stored
## this is currently hardcoded and shown in inspector
## this will likely be chosen before tank creation
@export var tank_type: WaterType = WaterType.Fresh

## fishCapacity is the amount of fish allowed in this tank
var fishCapacity = 10

## plantCapacity is the amount of plants allowed in this tank
var plantCapacity = 10

## fishList is an array which holds what fish are in the tank
var fishList: Array = []

## plantList is an array which holds what plants are in the tank
var plantList: Array = []

## harvestStatus is a bool which will turn true when it is time to harvest
## Might need one for each fish and plant
var harvestStatus = false

## tankName is the name of the tank
var tankName: String = "Awesome Tank"


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
		

		
## AddPlant
## This method checks if ther is room in the tank to add a plant
## if there are then it will add the given plant to plantList
func AddPlant(plantInstance):	
	if plantList.size() < plantCapacity:
		plantList.append(plantInstance)
		SpawnManager.SpawnPlant(self, plantInstance)
		## print("Added plant")
	else:
		## this needs to be a print statement
		## it should be a ui statment
		print("Tank is full")
		
	UiManager.ReloadAllUI()

## _can_drop_data
## checks to seee if data is acceptable to be dropped here
## also if tank has room for it
func _can_drop_data(_pos,data):
	if data is Node:
		if data is Fish && fishList.size() < fishCapacity:
			#print("Drop allowed: Tank has space.")
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

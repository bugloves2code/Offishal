## Fish Friends
## Last upadated 2/5/25 by Justin Ferreira
## Tank Script
## - This scrpt decribes the tank scene 
## the tank will hold fish and plants
## The tank is a where fish and plant harvest
## collection pop up will happen and mantaince stats
## will be presented 

extends Area2D
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
var fishList: Array

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
	if fishList.size() < fishCapacity:
		fishList.append(fishInstance)
		#print("Added Fish: " + fishInstance)
		print("Added Fish: ", fishInstance)
		print("Tank: ",tankName, " Fish Count: ", fishList.size())
	else:
		print("Tank is full of fish")
	
## RemoveFish
## This method checks in a given fish is inside the fishList
## if so it will take it out of the list and I believe delete it
## from memory 
func RemoveFish(fishInstance):
	if fishInstance in fishList:
		fishList.erase(fishInstance)
		fishInstance.queue_free()
		print("Removed Fish")
		
## AddPlant
## This method checks if ther is room in the tank to add a plant
## if there are then it will add the given plant to plantList
func AddPlant(plantInstance):
	if plantList < plantCapacity:
		plantList.append(plantInstance)
		print("Added plant: " + plantInstance)
	else:
		print("Tank is full")
	
## RemoveFish
## This method checks in a given plant is inside the plantList
## if so it will take it out of the list and I believe delete it
## from memory 
func RemovePlant(plantInstance):
	if plantInstance in plantList:
		plantList.erase(plantInstance)
		plantInstance.queue_free()
		print("Removed Plant")


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		## print("Clicked")
		var Main = get_parent()
		if Main and Main.has_method("show_ui_panel"):
			## print("UI?")
			Main.ReloadUI(self)
			Main.show_ui_panel(self)
		

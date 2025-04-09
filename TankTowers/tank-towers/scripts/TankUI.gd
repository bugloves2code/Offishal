## Fish Friends
## Last upadated 2/20/25 by Justin Ferreira
## TankUI Script
## - This script describes the UI layer for tanks
## this script is used to handle UI events
## UI events will be things such as add and removing fish

extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
## OnHarvestTankPressed this is the function that allows for the player to harvest
## all things that are harvestable in the tank this will probably become mutiple
## functions in the future
func OnHarvestTankPressed(tank):
	## If the tank can be harvested call the harvest function
	if(tank.harvestStatus):
		tank.HarvestTank()

## _on_create_tank_button_pressed is the function that is attached to the 
## Creat Tank Button and processes if a tank can be made and then adds it to
## the scene
func _on_create_tank_button_pressed() -> void:
	## print(tankList.size())
	UiManager.CloseFishUI()
	if PlayerManager.money >= 5:
		if TankManager.tankList.size() < TankManager.tankCapacity:
			## This sound effect makes me want the tank to fall
			## from the sky and land on the top of the tower
			$TankCreation.play();
			
			var new_instance = TankManager.tank_scene.instantiate()

			if TankManager.tankList.size() == 0:
				new_instance.position = Vector2(290,800)
				new_instance.tankName = "Dope Tank"
			else:
				new_instance.position = Vector2(290, 800 + (TankManager.tankList.size() * 200))
				new_instance.tankName = get_random_tank_name() 
			var vbox_node = get_tree().current_scene.get_node("Control/ScrollContainer/VBoxContainer")
			new_instance.get_node("TankLabel").text = new_instance.tankName
			TankManager.tankList.append(new_instance)

			if vbox_node:
				## print("main found")
				vbox_node.add_child(new_instance)
				#if TankManager.tankList.size() == 1:
					#vbox_node.move_child(new_instance, TankManager.tankList.size())
				#print(TankManager.tankList.size())
				vbox_node.move_child(new_instance, 1)
				## print(tankList.size())
			PlayerManager.money -= 5

## get_random_tank_name is currently a placeholder function so each tank
## has a random name and is easier to see what tank you're working with
## mostly for debug purposes soon the player will beable to name their own tanks
## not sure if this random generator should still be inside it so all tanks start with a name
## and can be renamed later
func get_random_tank_name() -> String:
	var tank_names = [
		"Oceanic Oasis",
		"Coral Cove",
		"Deep Blue",
		"Reef Retreat",
		"Abyssal Abode",
		"Marine Marvel",
		"Tidal Treasure",
		"Seabed Sanctuary",
		"Neptune's Nest",
		"Pearl Paradise",
		"Sunken Serenity",
		"Wave Whisperer",
		"Lagoon Lounge",
		"Shimmering Shallows",
		"Golden Grotto"
	]
	# Randomly select a name from the list
	var random_index = randi() % tank_names.size()
	return tank_names[random_index]

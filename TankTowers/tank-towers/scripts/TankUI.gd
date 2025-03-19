## Fish Friends
## Last upadated 2/20/25 by Justin Ferreira
## TankUI Script
## - This script describes the UI layer for tanks
## this script is used to handle UI events
## UI events will be things such as add and removing fish
## 

extends CanvasLayer

## add_fish_handler
var add_fish_handler: Callable

## harvest_handler
var harvest_handler: Callable

## add_plant_handler
var add_plant_handler: Callable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# _on_close_button_pressed is the function that procesess what happens when the player closes UI
func _on_close_button_pressed() -> void:
	self.hide()
	
	
## show_ui_panel is used to show Ui when a tank is clicked
## then process the tank information and populate the ui with it
func show_ui_panel(tank) -> void:
	## print(tank.tankName)
	var addfish_button = self.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/AddFish Button")
	var addplant_button = self.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/AddPlant Button")
	var tank_name_label = self.get_node("PanelContainer/GridContainer/TankName")
	var harvest_button = self.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HarvestButton")
	var fish_labels = []
	var fish_images = []
	var remove_buttons = []
	
	if tank_name_label and tank_name_label is Label:
		tank_name_label.text = tank.tankName
	if addfish_button and addfish_button is Button:
		## print("Add Button found")
		if add_fish_handler:
			addfish_button.pressed.disconnect(add_fish_handler)
			## print("Disconnected")
		add_fish_handler = func(): OnAddFishPressed(tank)
		addfish_button.pressed.connect(add_fish_handler)
	if harvest_button and harvest_button is Button:
		if harvest_handler:
			harvest_button.pressed.disconnect(harvest_handler)
		harvest_handler = func (): OnHarvestTankPressed(tank)
		harvest_button.pressed.connect(harvest_handler)
		if tank.harvestStatus == false:
			harvest_button.text = "                    "
	if addplant_button and addplant_button is Button:
		if add_plant_handler:
			addplant_button.pressed.disconnect(add_plant_handler)
		add_plant_handler = func(): OnAddPlantPressed(tank)
		addplant_button.pressed.connect(add_plant_handler)
	for i in range(1, 11):  # Assuming max 10 fish slots
		fish_labels.append(self.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/Fish%dLabel" % i))
		fish_images.append(self.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/Fish%dImage" % i))
		remove_buttons.append(self.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/Fish%dRemoveButton" % i))
	if tank.fishList.size() > 0:
		## print("We got fish")
		for i in range(tank.fishList.size()):
			fish_labels[i].show()
			fish_images[i].show()
			remove_buttons[i].show()
	else:
		for i in range(fish_labels.size()):
			fish_labels[i].hide()
			fish_images[i].hide()
			remove_buttons[i].hide()
	self.show()
	
## OnAddFishPressed 
## this function adds a fish to the tank
func OnAddFishPressed(tank):
	if tank.fishList.size() < tank.fishCapacity:
		## Bloop AudioStreamPlayer must be a child of
		## this script node for this to work
		$Bloop.play();
		
		## print("Bro we adding fish")
		## print(tank.tankName)
		#var fishInstance = "res://scenes/Fish.tscn"
		tank.AddFish(SpawnManager.SpawnFish(tank))
		ReloadUI(tank)
	else:
		## Bloop, but pitched down
		## - Definitely could name these nodes better, 
		##   but for now, I prioritize the funny for my sanity
		$Bleep.play();
		
		## Print needed for now
		## will need to be UI later
		
		print("Too many Fish")

## OnAddPlantPressed is the function that processes when the UI button
## Add Plant is pressed
func OnAddPlantPressed(tank):
	if tank.plantList.size() < tank.plantCapacity:
		tank.AddPlant(SpawnManager.SpawnFish(tank))
		ReloadUI(tank)
	else:
		## Print needed for now
		## will need to be UI later
		print("Too many Plants")
## ReloadUI
## This function is not working yet, but is meant to reload the Canvas Layer / UI
func ReloadUI(tank):
	var fish_labels = []
	var fish_images = []
	var remove_buttons = []
	var harvest_button = self.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HarvestButton")
	
	if harvest_button and harvest_button is Button:
		if tank.harvestStatus == true:
			harvest_button.text = "Harvest"
		else:
			harvest_button.text = "                    "

	# Get references to the UI elements
	for i in range(1, 11):  # Assuming max 10 fish slots
		fish_labels.append(self.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/Fish%dLabel" % i))
		fish_images.append(self.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/Fish%dImage" % i))
		remove_buttons.append(self.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/Fish%dRemoveButton" % i))

	# Clear all fish slots first
	for i in range(fish_labels.size()):
		fish_labels[i].text = ""  # Clear the label
		fish_labels[i].hide()     # Hide the label
		fish_images[i].texture = null  # Clear the image
		fish_images[i].hide()     # Hide the image
		remove_buttons[i].hide()  # Hide the remove button

	# Populate the UI with the current fishList
	if tank.fishList.size() > 0:
		## print("Reloading UI with fish data")
		for i in range(tank.fishList.size()):
			if i >= fish_labels.size():
				break  # Don't exceed the number of UI slots

			var fish = tank.fishList[i]
			fish_labels[i].text = "Jimmy"  # Set the fish name
			fish_labels[i].show() 
			## Fish Image Goes here
			## for UI               
			## Show the label
			fish_images[i].texture = load("res://assets/guppy.PNG")  # Set the fish image
			fish_images[i].show()               # Show the image
			remove_buttons[i].show() 
			
## OnHarvestTankPressed this is the function that allows for the player to harvest
## all things that are harvestable in the tank this will probably become mutiple
## functions in the future
func OnHarvestTankPressed(tank):
	## If the tank can be harvested call the harvest function
	if(tank.harvestStatus):
		tank.HarvestTank()
	ReloadUI(tank)

## _on_create_tank_button_pressed is the function that is attached to the 
## Creat Tank Button and processes if a tank can be made and then adds it to
## the scene
func _on_create_tank_button_pressed() -> void:
	## print(tankList.size())
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
		var scroll_node = get_tree().current_scene.get_node("Control/ScrollContainer")
		TankManager.tankList.append(new_instance)

		if vbox_node:
			## print("main found")
			vbox_node.add_child(new_instance)
			#if TankManager.tankList.size() == 1:
				#vbox_node.move_child(new_instance, TankManager.tankList.size())
			#print(TankManager.tankList.size())
			vbox_node.move_child(new_instance, 1)
			## print(tankList.size())

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

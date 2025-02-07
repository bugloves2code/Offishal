extends Node
class_name TankManager

## ui_panel 
## this is the panel hookup to the main Ui which
## shows tank data and allows editing to tank
@export var ui_panel: CanvasLayer

## tank_scene 
## tank_scene holds then tank so we can instaniate it
## and edit it in the future
var tank_scene =  load("res://scenes/Tank.tscn")

## tankList
## this is the List which contains all tanks 
var tankList: Array = []

## add_fish_handler
var add_fish_handler: Callable

## harvest_handler
var harvest_handler: Callable

## add_plant_handler
var add_plant_handler: Callable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_panel.hide()

## _on_close_button_pressed is used to process when user wants
## to get out of the UI
func _on_close_button_pressed() -> void:
	ui_panel.hide()
	
## show_ui_panel is used to show Ui when a tank is clicked
## then process the tank information and populate the ui with it
func show_ui_panel(tank) -> void:
	print(tank.tankName)
	var addfish_button = ui_panel.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/AddFish Button")
	var addplant_button = ui_panel.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/AddPlant Button")
	var tank_name_label = ui_panel.get_node("PanelContainer/GridContainer/TankName")
	var harvest_button = ui_panel.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HarvestButton")
	var fish_labels = []
	var fish_images = []
	var remove_buttons = []
	
	if tank_name_label and tank_name_label is Label:
		tank_name_label.text = tank.tankName
	if addfish_button and addfish_button is Button:
		print("Add Button found")
		if add_fish_handler:
			addfish_button.pressed.disconnect(add_fish_handler)
			print("Disconnected")
		add_fish_handler = func(): OnAddFishPressed(tank)
		addfish_button.pressed.connect(add_fish_handler)
	if harvest_button and harvest_button is Button:
		if harvest_handler:
			harvest_button.pressed.disconnect(harvest_handler)
		harvest_handler = func (): HarvestTank(tank)
		harvest_button.pressed.connect(harvest_handler)
		if tank.harvestStatus == false:
			harvest_button.text = "                    "
	if addplant_button and addplant_button is Button:
		if add_plant_handler:
			addplant_button.pressed.disconnect(add_plant_handler)
		add_plant_handler = func(): OnAddPlantPressed(tank)
		addplant_button.pressed.connect(add_plant_handler)
	for i in range(1, 11):  # Assuming max 10 fish slots
		fish_labels.append(ui_panel.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/Fish%dLabel" % i))
		fish_images.append(ui_panel.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/Fish%dImage" % i))
		remove_buttons.append(ui_panel.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/Fish%dRemoveButton" % i))
	if tank.fishList.size() > 0:
		print("We got fish")
		for i in range(tank.fishList.size()):
			fish_labels[i].show()
			fish_images[i].show()
			remove_buttons[i].show()
	else:
		for i in range(fish_labels.size()):
			fish_labels[i].hide()
			fish_images[i].hide()
			remove_buttons[i].hide()
	ui_panel.show()

## OnAddFishPressed 
## this function adds a fish to the tank
func OnAddFishPressed(tank):
	if tank.fishList.size() < tank.fishCapacity:
		print("Bro we adding fish")
		print(tank.tankName)
		#var fishInstance = "res://scenes/Fish.tscn"
		tank.AddFish(SpawnManager.SpawnFish(tank))
		ReloadUI(tank)
	else:
		print("Too many Fish")
	
func OnAddPlantPressed(tank):
	if tank.plantList.size() < tank.plantCapacity:
		tank.AddPlant(SpawnManager.SpawnFish(tank))
		ReloadUI(tank)
	else:
		print("Too many Plants")
## ReloadUI
## This function is not working yet, but is meant to reload the Canvas Layer / UI
func ReloadUI(tank):
	var fish_labels = []
	var fish_images = []
	var remove_buttons = []
	var harvest_button = ui_panel.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HarvestButton")
	
	if harvest_button and harvest_button is Button:
		if tank.harvestStatus == true:
			harvest_button.text = "Harvest"
		else:
			harvest_button.text = "                    "

	# Get references to the UI elements
	for i in range(1, 11):  # Assuming max 10 fish slots
		fish_labels.append(ui_panel.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/Fish%dLabel" % i))
		fish_images.append(ui_panel.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/Fish%dImage" % i))
		remove_buttons.append(ui_panel.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/Fish%dRemoveButton" % i))

	# Clear all fish slots first
	for i in range(fish_labels.size()):
		fish_labels[i].text = ""  # Clear the label
		fish_labels[i].hide()     # Hide the label
		fish_images[i].texture = null  # Clear the image
		fish_images[i].hide()     # Hide the image
		remove_buttons[i].hide()  # Hide the remove button

	# Populate the UI with the current fishList
	if tank.fishList.size() > 0:
		print("Reloading UI with fish data")
		for i in range(tank.fishList.size()):
			if i >= fish_labels.size():
				break  # Don't exceed the number of UI slots

			var fish = tank.fishList[i]
			fish_labels[i].text = "Jimmy"  # Set the fish name
			fish_labels[i].show()               # Show the label
			fish_images[i].texture = load("res://assets/download.jpg")  # Set the fish image
			fish_images[i].show()               # Show the image
			remove_buttons[i].show() 


func _on_create_tank_button_pressed() -> void:
	print(tankList.size())
	var new_instance = tank_scene.instantiate()
	
	if tankList.size() == 0:
		new_instance.position = Vector2(-20,700)
		new_instance.tankName = "Dope Tank"
	else:
		new_instance.position = Vector2(-20, 700 - (tankList.size() * 200))
		new_instance.tankName = get_random_tank_name() 
	var main_node = get_tree().current_scene
	tankList.append(new_instance)
	
	if main_node:
		print("main found")
		main_node.add_child(new_instance)
		print(tankList.size())

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
	
func HarvestTank(tank):
	## Add money to player
	tank.harvestStatus = false
	ReloadUI(tank)
	

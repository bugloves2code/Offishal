extends Node
class_name TankManager

## ui_panel is the panel hookup to the main Ui which
## show tank data and allows editing to tank
@export var ui_panel: CanvasLayer
var tank_scene =  load("res://scenes/Tank.tscn")

var tankList: Array = []
var add_fish_handler: Callable

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
	var selectedtank = null
	print(tank.tankName)
	var addfish_button = ui_panel.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/AddFish Button")
	var addplant_button = ui_panel.get_node("PanelContainer/GridContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/AddPlant Button")
	var tank_name_label = ui_panel.get_node("PanelContainer/GridContainer/TankName")
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
	print("Bro we adding fish")
	print(tank.tankName)
	#var fishInstance = "res://scenes/Fish.tscn"
	tank.AddFish(SpawnManager.SpawnFish(tank))
	ReloadUI(tank)
	
## ReloadUI
## This function is not working yet, but is meant to reload the Canvas Layer / UI
func ReloadUI(tank):
	for fish in tank.fishList.size():
		for i in range(1, tank.fishList.size()):
			print(tank.fishList[i], i)


func _on_create_tank_button_pressed() -> void:
	print(tankList.size())
	var new_instance = tank_scene.instantiate()
	
	if tankList.size() == 0:
		new_instance.position = Vector2(-20,700)
	else:
		new_instance.position = Vector2(-20, 700 - (tankList.size() * 200))
	var main_node = get_tree().current_scene
	tankList.append(new_instance)
	
	if main_node:
		print("main found")
		main_node.add_child(new_instance)
		print(tankList.size())
	

extends CanvasLayer


@export var SaltwaterCheckbox : CheckBox

@export var FreshwaterCheckbox : CheckBox

@export var PriceLabel : Label

@export var TankNameLabel : Label

@export var CreateTankButton : Button

@export var CancelButton : Button

var saltwater = null

var freshwater = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func CreateTank():
	if PlayerManager.money >= 5:
		if TankManager.tankList.size() < TankManager.tankCapacity:
			## This sound effect makes me want the tank to fall
			## from the sky and land on the top of the tower
			##$TankCreation.play();
			
			var new_instance = TankManager.tank_scene.instantiate()
			
			if saltwater == true:
				new_instance.tank_type = ThEnums.WaterType.Salt
				new_instance.get_node("Sprite2D").texture = load("res://assets/saltwatertank.png")
			if freshwater == true:
				new_instance.tank_type = ThEnums.WaterType.Fresh
				new_instance.get_node("Sprite2D").texture = load("res://assets/tank.PNG")
				

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


func _on_cancel_button_pressed() -> void:
	self.visible = false


func _on_create_tank_button_pressed() -> void:
	CreateTank()
	self.visible = false
	


func _on_fresh_water_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		# Untoggle Saltwater if Freshwater is toggled
		SaltwaterCheckbox.button_pressed = false
	# Update variables to match checkbox states
	freshwater = toggled_on
	saltwater = SaltwaterCheckbox.button_pressed

func _on_saltwater_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		# Untoggle Freshwater if Saltwater is toggled
		FreshwaterCheckbox.button_pressed = false
	# Update variables to match checkbox states
	saltwater = toggled_on
	freshwater = FreshwaterCheckbox.button_pressed

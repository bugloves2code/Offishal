extends CanvasLayer


@export var SaltwaterCheckbox : CheckBox

@export var FreshwaterCheckbox : CheckBox

@export var PriceLabel : Label

@export var TankNameLabel : Label

@export var NameLineEdit: LineEdit

@export var CreateTankButton : Button

@export var CancelButton : Button

var saltwater = null

var freshwater = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NameLineEdit.hide()
	TankNameLabel.mouse_filter = Control.MOUSE_FILTER_STOP
	NameLineEdit.focus_exited.connect(_on_name_line_edit_focus_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func CreateTank():
	if PlayerManager.money >= PlayerManager.currentTankPrice:
		if TankManager.tankList.size() < TankManager.tankCapacity:
			## This sound effect makes me want the tank to fall
			## from the sky and land on the top of the tower
			##$TankCreation.play();
			
			var new_instance = TankManager.tank_scene.instantiate()
			
			 # Use the label's text as the tank name
			new_instance.tankName = TankNameLabel.text
			
			if freshwater == null:
				Notifier.push_notification("SELECT A TANK TYPE")
				return
			
			if saltwater == true:
				new_instance.tank_type = ThEnums.WaterType.Salt
				new_instance.get_node("Sprite2D").texture = load("res://assets/saltwatertank.png")
			if freshwater == true:
				new_instance.tank_type = ThEnums.WaterType.Fresh
				new_instance.get_node("Sprite2D").texture = load("res://assets/tank.PNG")
				
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
			PlayerManager.money -= PlayerManager.currentTankPrice
	else:
		Notifier.push_notification("YOU DON'T HAVE ENOUGH $")
			
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
	ReloadTankCreationUI()
	self.visible = false


func _on_create_tank_button_pressed() -> void:
	CreateTank()
	if freshwater != null && PlayerManager.money >= PlayerManager.currentTankPrice:
		self.visible = false
	UiManager.ShowInventory()
	UiManager.ReloadAllUI()
	


func _on_fresh_water_check_box_toggled(toggled_on: bool) -> void:
	PlayerManager.UpdateTankPrice(false)
	if toggled_on:
		PriceLabel.text = str("$",PlayerManager.currentTankPrice)
		# Untoggle Saltwater if Freshwater is toggled
		SaltwaterCheckbox.button_pressed = false
	# Update variables to match checkbox states
	freshwater = toggled_on
	saltwater = SaltwaterCheckbox.button_pressed
	

func _on_saltwater_check_box_toggled(toggled_on: bool) -> void:
	PlayerManager.UpdateTankPrice(true)
	if toggled_on:
		PriceLabel.text = str("$",PlayerManager.currentTankPrice)
		# Untoggle Freshwater if Saltwater is toggled
		FreshwaterCheckbox.button_pressed = false
	# Update variables to match checkbox states
	saltwater = toggled_on
	freshwater = FreshwaterCheckbox.button_pressed	
	
func ReloadTankCreationUI():
	NameLineEdit.text = ""  # Clear the LineEdit text
	TankNameLabel.text = get_random_tank_name()  # Reset to a random default name
	NameLineEdit.hide()  # Hide the LineEdit
	TankNameLabel.show()  # Show the label
	
	$Panel/PriceLabel.text = "$"
	$Panel/SaltwaterCheckBox.button_pressed = false
	$Panel/FreshWaterCheckBox.button_pressed = false
	freshwater = null
	saltwater = null
	


func _on_tankname_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		TankNameLabel.hide()
		NameLineEdit.show()
		NameLineEdit.text = TankNameLabel.text  # Load current text
		NameLineEdit.grab_focus()  # Start typing immediately


func _on_tank_name_input_text_submitted(new_text: String) -> void:
	TankNameLabel.text = new_text
	NameLineEdit.hide()
	TankNameLabel.show()
	
func _on_name_line_edit_focus_exited() -> void:
	# Called when clicking outside the LineEdit
	TankNameLabel.text = NameLineEdit.text
	NameLineEdit.hide()
	TankNameLabel.show()

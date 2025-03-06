## Fish Friends
## Last upadated 2/20/25 by Justin Ferreira
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

signal addFish
signal tankClicked
## inititial_click_position is a Vextor2 which holds the click of the player 
## to better handle when the player is trying to scroll and when they are accessing UI
var initial_click_position: Vector2 = Vector2.ZERO

## movement_threshold is the distance the player is allowed 
## to move the mouse before it is considered that they are scrolling
var movement_threshold: float = 10.0  # Adjust this value to control sensitivity


## AddFish 
## This method checks if ther is room in the tank to add a fish
## if there are then it will add the given fish to fishList
func AddFish(fishInstance):
	if fishList.size() == 0 && plantList.size() == 0:
		$Harvest.start()
		
	if fishList.size() < fishCapacity:
		fishList.append(fishInstance)
		## emit signal for adding fish
		emit_signal("addFish")
		## print("Added Fish: " + fishInstance)
		## print("Added Fish: ", fishInstance)
		## print("Tank: ",tankName, " Fish Count: ", fishList.size())
	else:
		## this needs to be a print statement
		## it should be a ui statment
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
	if fishList.size() == 0 && plantList.size() == 0:
		$Harvest.start()
		
	if plantList.size() < plantCapacity:
		plantList.append(plantInstance)
		## print("Added plant")
	else:
		## this needs to be a print statement
		## it should be a ui statment
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

## HarvestTank
## This method harvests the fish and plants in tank and adds
## money based on the number of fish and plants in the tank
## and resets the harvest timer and harvestStatus
func HarvestTank():
	PlayerManager.money += fishList.size() + plantList.size()
	## print(PlayerManager.money)
	harvestStatus = false
	$Harvest.start()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		## emit signal for tutorial
		emit_signal("tankClicked")
		print("Clicked")
		var Main = get_parent()
		var Ui_Panel = Main.get_node("Tank UI - CanvasLayer")
		if Ui_Panel and Ui_Panel.has_method("show_ui_panel"):
			## print("UI?")
			Ui_Panel.ReloadUI(self)
			Ui_Panel.show_ui_panel(self)
		
## tank_pressed is the function that checks the input of the player if they are
## touch the tank it will allow UI to show up if the player is not scrolling
func tank_pressed(event: InputEvent) -> void:
	# Print the type of event being processed
	#print("Event type:", event.get_class())
	# Handle mouse button or touch press events
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		# For mouse input, ensure it's a left click and not a scroll event
		if event is InputEventMouseButton:
			#print("Mouse button event - Button index:", event.button_index, "Pressed:", event.is_pressed())
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				# Store the initial click position
				initial_click_position = make_input_local(event).position
				#print("Left mouse button pressed - Initial position:", initial_click_position)
			elif event is InputEventScreenTouch:
				if event.is_pressed():
					initial_click_position = make_input_local(event).position
					#print("Touch pressed - Initial position:", initial_click_position)
			
## _input detects all input to better seperate if the player is 
## trying to scroll or access the UI panel
func _input(event: InputEvent) -> void:
	# Handle mouse motion or touch drag events
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		#print("Motion/Drag event detected")
		#print("Initial click position: ", initial_click_position)
		#print("Event Position: ", event.position)
		if initial_click_position != Vector2.ZERO:  # Only check if there's an initial position
			var local_event_position = make_input_local(event).position
			var distance_moved = initial_click_position.distance_to(local_event_position)
			#print("Distance moved: ", distance_moved)
			if distance_moved > movement_threshold:
				initial_click_position = Vector2.ZERO # Reset to prevent UI display
				#print("Movement detected - UI display canceled")
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed()) or (event is InputEventScreenTouch and not event.is_pressed()):
			if initial_click_position != Vector2.ZERO:
				#print("No significant movement - showing UI")
				var Main = get_tree().current_scene
				var Ui_Panel = Main.get_node("Tank UI - CanvasLayer")
				if Ui_Panel and Ui_Panel.has_method("show_ui_panel"):
					Ui_Panel.ReloadUI(self)
					Ui_Panel.show_ui_panel(self)
			else:
				#print("Significant movement detected earlier - UI display canceled")
				initial_click_position = Vector2.ZERO
			initial_click_position = Vector2.ZERO

## _on_harvest_timeout
## Stops the harvest timer and sets the harvestStatus to true
## Resets the UI so that the harvest button becomes valid
func _on_harvest_timeout() -> void:
	harvestStatus = true
	$Harvest.stop()
	
	var Main = get_tree().current_scene
	var Ui_Panel = Main.get_node("Tank UI - CanvasLayer")
	if Ui_Panel and Ui_Panel.has_method("show_ui_panel"):
		Ui_Panel.ReloadUI(self)

	

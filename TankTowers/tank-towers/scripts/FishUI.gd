## Fish Friends
## Last upadated 4/1/25 by Justin Ferreira
## FishUI Script
## - This Script describes how FishUI works
## this script has an instance of fish and
## displays its information properly and allows
## player to interact with fish

extends CanvasLayer

## Holds actual Fish
var fish : CharacterBody2D

## Callables to attach functions
## to buttons
var _on_put_inventory: Callable
var _close_ui: Callable

@onready var harvest_timer_label: Label = $Panel/HarvestTimeLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if harvest_timer_label:
		harvest_timer_label.text = "Harvest Time: --"
		harvest_timer_label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if fish and self.visible and harvest_timer_label:
	# Update the timer label if the fish is not harvestable
		var harvest_timer = fish.get_node("Harvest") as Timer
		if harvest_timer and not fish.harvestStatus:
			var time_left = harvest_timer.time_left
			harvest_timer_label.text = "Harvest Time: %.1f s" % time_left
			harvest_timer_label.visible = true
		else:
			harvest_timer_label.text = "Harvest Time: Ready"
			harvest_timer_label.visible = true
	

## loadFish
## gets instance of the fish and assigns it
## to the fish variable here to properly access
## fish 
func loadFish(fishInstance: CharacterBody2D):
	fish = fishInstance

## loadFishUI
## Takes all important information and displays it
## on the FishUI
func loadFishUI():
	$Panel/FishNameLabel.text = fish.fishname
	$Panel/AgeLabel.text ="Age: %s" % fish.age
	$Panel/TypeLabel.text = ThEnums.get_species_name(fish.Species)
	
	if harvest_timer_label:
		var harvest_timer = fish.get_node("Harvest") as Timer
		if harvest_timer and not fish.harvestStatus:
			harvest_timer_label.text = "Harvest Time: %.1f s" % harvest_timer.time_left
			harvest_timer_label.visible = true
		else:
			harvest_timer_label.text = "Harvest Time: Ready"
			harvest_timer_label.visible = true
	
	if _on_put_inventory:
		$Panel/PutinInventoryButton.pressed.disconnect(_on_put_inventory)
		_on_put_inventory = func(): PutInInventory()
		$Panel/PutinInventoryButton.pressed.connect(_on_put_inventory)
	else:
		_on_put_inventory = func(): PutInInventory()
		$Panel/PutinInventoryButton.pressed.connect(_on_put_inventory)
	if _close_ui:
		$Panel/CloseButton.pressed.disconnect(_close_ui)
		_close_ui = func(): CloseUI()
		$Panel/CloseButton.pressed.connect(_close_ui)
	else:
		_close_ui = func(): CloseUI()
		$Panel/CloseButton.pressed.connect(_close_ui)
	self.visible = true
	
## PutInInventory
## allows player to put fis back in their inventory
func PutInInventory():
	PlayerManager.AddMarineLife(fish)
	UiManager.CloseFishUI()
	var tank_container = get_tree().get_root().get_node("Main/Control/ScrollContainer/VBoxContainer")
	if tank_container:
		for child in tank_container.get_children():
			if child is Tank: # Ensure we're only checking Tank nodes
				if child.get_children().has(fish):
					if fish in child.fishList:
						child.fishList.erase(fish)
					if fish.get_parent() == child:
						child.remove_child(fish)
						
						

		# Optional: Remove from scene tree if parented to tank
		
	
	UiManager.ReloadAllUI()
	
## CloseUI
## closes ui
func CloseUI():
	self.visible = false
	UiManager.ShowInventory()

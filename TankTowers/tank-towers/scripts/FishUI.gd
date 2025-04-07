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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

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

	var tank_container = get_tree().get_root().get_node("Main/Control/ScrollContainer/VBoxContainer")
	if tank_container:
		for child in tank_container.get_children():
			if child is Tank: # Ensure we're only checking Tank nodes
				if child.get_children().has(fish):
					if fish in child.fishList:
						child.fishList.erase(fish)
					if fish.get_parent() == child:
						child.remove_child(fish)
					if self in UiManager.FishUIs:
						UiManager.FishUIs.erase(self)
						

		# Optional: Remove from scene tree if parented to tank
		
	
	UiManager.ReloadAllUI()
	
## CloseUI
## closes ui
func CloseUI():
	self.visible = false

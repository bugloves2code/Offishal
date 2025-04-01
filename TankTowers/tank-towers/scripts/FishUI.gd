extends CanvasLayer


var fish : CharacterBody2D

var _on_put_inventory: Callable
var _close_ui: Callable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func loadFish(fishInstance: CharacterBody2D):
	fish = fishInstance
	
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
	
func PutInInventory():
	var PlayerUI = get_tree().get_root().get_node("Main/PlayerUI")
	
	PlayerManager.AddMarineLife(fish)

	var tank_container = get_tree().get_root().get_node("Main/Control/ScrollContainer/VBoxContainer")
	if tank_container:
		for child in tank_container.get_children():
			if child is Tank: # Ensure we're only checking Tank nodes
				print(child.name)
				if child.get_children().has(fish):
					# Remove from list
					child.get_children().erase(fish)
					if fish.get_parent() == child:
						child.remove_child(fish)
						

		# Optional: Remove from scene tree if parented to tank
		
	
	PlayerUI.ReloadAllUI()
	
func CloseUI():
	self.visible = false

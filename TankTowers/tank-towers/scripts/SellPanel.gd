## Fish Friends
## Last upadated 4/1/25 by Justin Ferreira
## SellPanel Script
## Controls a Panel for the sell shop the the player can sell items

extends Control


## Label for price
@onready var price_label = $PriceLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connects functions for decteding objects being hovered over panel
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

## _on_mouse_entered
## checks if mouse is dragging an item
## also since connected by mouse_entered
## knows when mouse is hovering above the panel
func _on_mouse_entered():
	#print("Mouse enter")
	if PlayerManager.is_dragging:
		update_price_label()
		
## _on_mouse_exited
## checks if mouse has stopped hovering over panel
## by being connected with mouse_exited. Then handles 
## UI that should be changed
func _on_mouse_exited():
	price_label.hide()
	
## _can_drop_data
## detected if item can be dropped in area
func _can_drop_data(_pos, data):
	return data is MarineLife
	
## _drop_data
## takes data that was dropped into the sell section
## and processes it so the player gets paid and item is
## deleted
func _drop_data(_pos, data):
	if data is MarineLife:
		PlayerManager.money += data.sell_price
		PlayerManager.marineLifeInventory.erase(data)
		data.queue_free()
		#print(get_tree().current_scene)
		get_tree().current_scene.get_node("PlayerUI").ReloadAllUI()
		
## update_price_label
## Show the price of the item hovering over the sell panel
func update_price_label():
	if PlayerManager.current_dragged_item:
		price_label.text = "Sell for: %d" % PlayerManager.current_dragged_item.sell_price
		price_label.show()

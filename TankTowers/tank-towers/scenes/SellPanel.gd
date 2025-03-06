extends Control

@onready var price_label = $PriceLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 100
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_mouse_entered():
	print("Mouse enter")
	if PlayerManager.is_dragging:
		update_price_label()
		
func _on_mouse_exited():
	price_label.hide()
	
func _can_drop_data(_pos, data):
	return data is MarineLife
	
func _drop_data(_pos, data):
	if data is MarineLife:
		PlayerManager.money += data.sell_price
		PlayerManager.marineLifeInventory.erase(data)
		data.queue_free()
		print(get_tree().current_scene)
		get_tree().current_scene.get_node("PlayerUI").ReloadAllUI()
		
func update_price_label():
	if PlayerManager.current_dragged_item:
		price_label.text = "Sell for: %d" % PlayerManager.current_dragged_item.sell_price
		price_label.show()

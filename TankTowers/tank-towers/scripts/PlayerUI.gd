## Fish Friends
## Last upadated 2/21/25 by Justin Ferreira
## PlayerUI Script
## - This Script is used to display and 
extends Node

var ShopStock: Array;

var drag_drop_menu = null

## Shop Item Scenes
var ShopItem = preload("res://scenes/ShopItem.tscn")

var FishScene = preload("res://scenes/Fish.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ShopStock.append({"texture": preload("res://assets/8bit-fish-basic-5.png"), "price": 1})
	ShopStock.append({"texture": preload("res://assets/8bit-fish-basic-5.png"), "price": 1})
	ShopStock.append({"texture": preload("res://assets/8bit-fish-basic-5.png"), "price": 1})
	ShopStock.append({"texture": preload("res://assets/8bit-fish-basic-5.png"), "price": 1})
	ShopStock.append({"texture": preload("res://assets/8bit-fish-basic-5.png"), "price": 1})
	drag_drop_menu = get_tree().get_root().get_node("Main/DragDropMenu")
	print(drag_drop_menu)
	LoadShop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$BottomPanel/MoenyCount.text = str(PlayerManager.money)


func _on_menu_pressed() -> void:
	#print("Menu clicked")
	var MenuPanel = $MenuPanel
	var ShopPanel = $ShopPanel
	#print(MenuPanel.visible)
	if MenuPanel && not MenuPanel.visible && not ShopPanel.visible:
		MenuPanel.visible = true
	else:
		MenuPanel.visible = false
		ShopPanel.visible = false


func _on_shop_button_pressed() -> void:
	var ShopPanel = $ShopPanel
	var MenuPanel = $MenuPanel
	MenuPanel.visible = false
	ShopPanel.visible = true


func _on_fish_pedia_button_pressed() -> void:
	print("FishPeida Clicked")


func _on_settings_button_pressed() -> void:
	print("Settings Clicked")


func _on_back_button_pressed() -> void:
	var ShopPanel = $ShopPanel
	var MenuPanel = $MenuPanel
	ShopPanel.visible = false
	MenuPanel.visible = true
	
func LoadShop():
	for item in ShopStock:
		# Instantiate the ShopItem scene
		var instance = ShopItem.instantiate()
		
		# Access the nodes in the instance
		var image = instance.get_node("GridContainer/Image")
		#print(image)
		var price = instance.get_node("GridContainer/Price")
		#print(price)
		var buyButton = instance.get_node("GridContainer/BuyButton")
		
		# Set the texture and price
		image.texture = item.texture
		price.text = str(item.price)
		# Connect the BuyButton to a function
		buyButton.connect("pressed", Callable(self, "_on_BuyButton_pressed").bind(item, instance))
		
		# Add the instance to the HBoxContainer
		$ShopPanel/ScrollContainer/HBoxContainer.add_child(instance)
		
func _on_BuyButton_pressed(item, instance):
	#print("Button Linked")
	# Check if the player has enough money
	if PlayerManager.money >= item["price"]:
		# Deduct the price from the player's money
		PlayerManager.money -= item["price"]
		# Remove the item from ShopStock
		ShopStock.erase(item)
		
		# Add a fish to the PlayerInventory
		var fish_instance = FishScene.instantiate()
		PlayerManager.marineLifeInventory.append(fish_instance)
		
		# Reload the Shop UI
		ReloadShopUI()
		
		# Reload the Shop UI
		drag_drop_menu.populate_hbox_container()
func ReloadShopUI():
	# Clear existing children in the HBoxContainer
	for child in $ShopPanel/ScrollContainer/HBoxContainer.get_children():
		child.queue_free()
		
	# Reload the ShopStock items
	LoadShop()

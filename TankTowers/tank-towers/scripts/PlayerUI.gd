## Fish Friends
## Last upadated 4/1/25 by Justin Ferreira
## PlayerUI Script
## - This Script is used to display things the player
## needs to interact with
extends Node

## Arrays for the Fish Shop and Plant Shop
var ShopStock: Array;
var PlantShopStock: Array;

## drag_drop_menu
## holds the UI for drag drops
var drag_drop_menu = null

## Container that hold Inventory in sell shop
@onready var grid_container = $SellShopPanel/ScrollContainer/GridContainer

## Settings Panel
## Sliders
@onready var master_slider = $SettingsPanel/MasterSlider
@onready var music_slider = $SettingsPanel/MusicSlider
@onready var sfx_slider = $SettingsPanel/SFXSlider
@onready var mute_check = $SettingsPanel/MuteCheckBox
## Check Boxes


## Scenes
var ShopItem = preload("res://scenes/ShopItem.tscn")

var drag_drop_scene = preload("res://scenes/DragDrop.tscn")

var FishScene = preload("res://scenes/Fish.tscn")

var PlantScene = preload("res://scenes/Plant.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Gets Player Level
	ShowPlayerLevel()
	# Load current values
	master_slider.value = SettingsManager.settings.audio.master_volume
	music_slider.value = SettingsManager.settings.audio.music_volume
	sfx_slider.value = SettingsManager.settings.audio.sfx_volume
	mute_check.button_pressed = SettingsManager.settings.audio.muted
	# Connect signal
	mute_check.toggled.connect(_on_mute_toggled)
	
	## Sets up the initial shop
	StockShop()
	
	## Sets drag_drop_menu to the one on screen
	drag_drop_menu = get_tree().get_root().get_node("Main/DragDropMenu")
	#print(drag_drop_menu)
	
	## Loads the UI for the Shop section
	LoadShop()
	LoadSellShop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	## makes sure money stays consistent with any changes
	$Panel/MoenyCount.text = str(PlayerManager.money)


## _on_menu_pressed
## handles menu presses 
func _on_menu_pressed() -> void:
	#print("Menu clicked")
	var MenuPanel = $MenuPanel
	var ShopPanel = $ShopPanel
	var SellShopPanel = $SellShopPanel
	var SettingsPanel = $SettingsPanel
	
	var BottomPanel = $Panel
	var menuButton = BottomPanel.get_node("Menu")
	#print(MenuPanel.visible)
	if MenuPanel && not MenuPanel.visible && not ShopPanel.visible && not SellShopPanel.visible && not SettingsPanel.visible:
		MenuPanel.visible = true
		UiManager.CloseFishUI()
		menuButton.text = "X"
	else:
		MenuPanel.visible = false
		ShopPanel.visible = false
		SellShopPanel.visible = false
		SettingsPanel.visible = false
		menuButton.text = "Menu"

## _on_shop_pressed
## handles when shop button is clicked
func _on_shop_button_pressed() -> void:
	var ShopPanel = $ShopPanel
	var MenuPanel = $MenuPanel
	MenuPanel.visible = false
	ShopPanel.visible = true

## _on_fish_pedia_button_pressed
## handles when fishpedia button is clicked
func _on_fish_pedia_button_pressed() -> void:
	print("FishPeida Clicked")

## _on_ settings_button_pressed
## handles when settings button is clicked
func _on_settings_button_pressed() -> void:
	var SettingsPanel = $SettingsPanel
	var MenuPanel = $MenuPanel
	MenuPanel.visible = false
	SettingsPanel.visible = true

## _on_back_button_pressed
## brings you back to the menu
func _on_back_button_pressed() -> void:
	var ShopPanel = $ShopPanel
	var SellShopPanel = $SellShopPanel
	var MenuPanel = $MenuPanel
	var SettingsPanel = $SettingsPanel
	ShopPanel.visible = false
	SellShopPanel.visible = false
	SettingsPanel.visible = false
	MenuPanel.visible = true
	
## LoadShop
## Loads the shop stock UI
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
	
	for item in PlantShopStock:
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
		buyButton.connect("pressed", Callable(self, "_on_BuyPlantButton_pressed").bind(item, instance))
		
		$ShopPanel/PlantScrollContainer/HBoxContainer.add_child(instance)
		
## LoadSellShop
## Loads Sell Shop UI
func LoadSellShop():
	for child in grid_container.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	for item in PlayerManager.marineLifeInventory:
		var drag_drop_instance = drag_drop_scene.instantiate()
		
		#Access the Sprite2D node from the Fish Scene
		var item_sprite = item.get_node("Sprite2D")
		
		#Set the texture of the DragDrop scene to the fish's texture
		if item_sprite and item_sprite.texture:
			#print("Fish has get texture")
			drag_drop_instance.texture = item_sprite.texture
		drag_drop_instance.drag_info = item
			
		grid_container.add_child(drag_drop_instance)

## Buy Butttons


## _on_BuyButton_pressed
## Buy Button for Fish
## allows player to get new fish in their inventory
func _on_BuyButton_pressed(item, instance):
	#print("Button Linked")
	# Check if the player has enough money
	if PlayerManager.money >= item["price"]:
		# Deduct the price from the player's money
		PlayerManager.money -= item["price"]
		# Remove the item from ShopStock
		
		# Add a fish to the PlayerInventory
		var fish_instance = FishScene.instantiate()
		PlayerManager.marineLifeInventory.append(fish_instance)
		
		# Reload the UI
		UiManager.ReloadAllUI()
		
## _on_BuyPlantButton_pressed
## Buy Button for Plant
## allows player to get new plant in their inventory
func _on_BuyPlantButton_pressed(item, instance):
	#print("Button Linked")
	# Check if the player has enough money
	if PlayerManager.money >= item["price"]:
		# Deduct the price from the player's money
		PlayerManager.money -= item["price"]
		# Remove the item from ShopStock
		
		# Add a fish to the PlayerInventory
		var plant_instance = PlantScene.instantiate()
		PlayerManager.marineLifeInventory.append(plant_instance)
		
		# Reload the UI
		UiManager.ReloadAllUI()

## ReloadShopUI
## clears shop and adds current shop
## to it
func ReloadShopUI():
	# Clear existing children in the HBoxContainer
	for child in $ShopPanel/ScrollContainer/HBoxContainer.get_children():
		child.queue_free()
	
	for child in $ShopPanel/PlantScrollContainer/HBoxContainer.get_children():
		child.queue_free()
		
	# Reload the ShopStock items
	LoadShop()

## ReloadSellShopUI
## clears up sell shop and adds current inventory
## to the sell shop area
func ReloadSellShopUI():
	# Clear existing children in the HBoxContainer
	for child in $SellShopPanel/ScrollContainer/GridContainer.get_children():
		child.queue_free()
		
	# Reload the ShopStock items
	LoadSellShop()

## ShowPlayerLevel
## gets player level and displays it
func ShowPlayerLevel():
	var LevelLabel = $Panel/LevelLabel
	LevelLabel.text = "Level: %s" % PlayerManager.level
	
## _on_sell_button_pressed
## Switches to Sell screen when button pressed
func _on_sell_button_pressed() -> void:
	var ShopPanel = $ShopPanel
	var SellShopPanel = $SellShopPanel
	ShopPanel.visible = false
	SellShopPanel.visible = true

## _on_buy_button_pressed
## Switches to Buy screen when button pressed
func _on_buy_button_pressed() -> void:
	var ShopPanel = $ShopPanel
	var SellShopPanel = $SellShopPanel
	ShopPanel.visible = true
	SellShopPanel.visible = false
	
## _on_master_volume_changed
## handles master volume value when slider is used
func _on_master_volume_changed(value):
	SettingsManager.settings.audio.master_volume = value
	SettingsManager.apply_settings()
	SettingsManager.save_settings()
	
## _on_music_volume_changed
## handles music volume value when slider is used
func _on_music_volume_changed(value):
	SettingsManager.settings.audio.music_volume = value
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

## _on_sfx_volume_changed
## handles sfx volume value when slider is used
func _on_sfx_volume_changed(value):
	SettingsManager.settings.audio.sfx_volume = value
	SettingsManager.apply_settings()
	SettingsManager.save_settings()
	
## _on_mute_toggled
## changes mute ture and false
func _on_mute_toggled(toggled):
	SettingsManager.settings.audio.muted = toggled
	SettingsManager.apply_settings()
	SettingsManager.save_settings()
	master_slider.editable = not toggled
	music_slider.editable = not toggled
	sfx_slider.editable = not toggled
	if toggled:
		mute_check.add_theme_color_override("font_color", Color.RED)
	else:
		mute_check.remove_theme_color_override("font_color")
		
## StockShop
## Fills Shop with everything from Stock
func StockShop():
	ShopStock.append({"texture": preload("res://assets/guppy.png"), "price": 1})
	PlantShopStock.append({"texture": preload("res://assets/guppyGrass.PNG"), "price": 1})
	
		
	

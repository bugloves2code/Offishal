## Fish Friends
## Last upadated 4/1/25 by Justin Ferreira
## PlayerUI Script
## - This Script is used to display things the player
## needs to interact with
extends Node
signal shopPressed

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

var ClownFishScene = preload("res://scenes/ClownFish.tscn")

var AnemoneScene = preload("res://scenes/Anemone.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Gets Player Level
	ShowPlayerLevel()
	FillFishPediaStartPage()
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
	#LoadSellShop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	## makes sure money stays consistent with any changes
	$MoneyPanel/MoenyCount.text = str(PlayerManager.money)


## _on_menu_pressed
## handles menu presses 
func _on_menu_pressed() -> void:
	#print("Menu clicked")
	var MenuPanel = $MenuPanel
	var SettingsPanel = $SettingsPanel
	var FishPeidaPanel = $FishPediaStartPanel
	var DetailsPanel = $DetailsPanel
	
	var BottomPanel = $Panel
	var menuButton = BottomPanel.get_node("Menu")
	#print(MenuPanel.visible)
	if MenuPanel && not MenuPanel.visible && not SettingsPanel.visible && not FishPeidaPanel.visible && not DetailsPanel.visible:
		MenuPanel.visible = true
		UiManager.CloseFishUI()
		UiManager.CloseTankCreationUI()
		menuButton.text = "X"
	else:
		MenuPanel.visible = false
		SettingsPanel.visible = false
		FishPeidaPanel.visible = false
		DetailsPanel.visible = false
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
	$FishPediaStartPanel.visible = true
	$MenuPanel.visible = false

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
	var FishPediaPanel = $FishPediaStartPanel
	var DetailsPanel = $DetailsPanel
	var MenuPanel = $MenuPanel
	var SettingsPanel = $SettingsPanel
	FishPediaPanel.visible = false
	SettingsPanel.visible = false
	DetailsPanel.visible = false
	MenuPanel.visible = true
	
## LoadShop
## Loads the shop stock UI
func LoadShop():
	for item in ShopStock:
		# Instantiate the ShopItem scene
		var instance = ShopItem.instantiate() as ShopItem
		
		
		
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
		$ShopScrollContainer/HBoxContainer.add_child(instance)
	
	for item in PlantShopStock:
		# Instantiate the ShopItem scene
		var instance = ShopItem.instantiate() as ShopItem
		
		## when a new shop item is made, set the species to plant and then the type of plant
		##instance.Species = ThEnums.PlantSpecies.Guppygrass
		
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
		
		$ShopScrollContainer/HBoxContainer.add_child(instance)
		
## LoadSellShop
## Loads Sell Shop UI
#func LoadSellShop():
	#for child in grid_container.get_children():
		#child.queue_free()
	#
	#await get_tree().process_frame
	#
	#for item in PlayerManager.marineLifeInventory:
		#var drag_drop_instance = drag_drop_scene.instantiate()
		#
		##Access the Sprite2D node from the Fish Scene
		#var item_sprite = item.get_node("Sprite2D")
		#
		##Set the texture of the DragDrop scene to the fish's texture
		#if item_sprite and item_sprite.texture:
			##print("Fish has get texture")
			#drag_drop_instance.texture = item_sprite.texture
		#drag_drop_instance.drag_info = item
			#
		#grid_container.add_child(drag_drop_instance)

## Buy Butttons


## _on_BuyButton_pressed
## Buy Button for Fish
## allows player to get new fish in their inventory
func _on_BuyButton_pressed(item, instance):
	emit_signal("shopPressed")
	#print("Button Linked")
	# Check if the player has enough money
	if PlayerManager.money >= item["price"]:
		# Deduct the price from the player's money
		PlayerManager.money -= item["price"]
		# Remove the item from ShopStock
		
		##var fish_instance = item as ShopItem
		##print(fish_instance["Species"], item["Species"], instance["Species"])
		var fish
		if item["Species"] == ThEnums.FishSpecies.Guppy:
			## this will change to a different scene in the future
			fish = FishScene.instantiate() as Fish
			fish.Species = ThEnums.FishSpecies.Guppy
		elif item["Species"] == ThEnums.FishSpecies.Clownfish:
			fish = ClownFishScene.instantiate() as Fish
			fish.Species = ThEnums.FishSpecies.Clownfish
			
		# Add a fish to the PlayerInventory
		PlayerManager.marineLifeInventory.append(fish)
		
		# Reload the UI
		UiManager.ReloadAllUI()
	else:
		Notifier.push_notification("YOU CANNOT AFFORD THIS")
		
## _on_BuyPlantButton_pressed
## Buy Button for Plant
## allows player to get new plant in their inventory
func _on_BuyPlantButton_pressed(item, instance):
	emit_signal("shopPressed")
	#print("Button Linked")
	# Check if the player has enough money
	if PlayerManager.money >= item["price"]:
		# Deduct the price from the player's money
		PlayerManager.money -= item["price"]
		# Remove the item from ShopStock
		
		var plant
		if item["Species"] == ThEnums.PlantSpecies.Guppygrass:
			plant = PlantScene.instantiate() as Plant
			plant.Species = ThEnums.PlantSpecies.Guppygrass
		elif item["Species"] == ThEnums.PlantSpecies.Anemone:
			plant = AnemoneScene.instantiate() as Plant
			plant.Species = ThEnums.PlantSpecies.Anemone
		
		# Add a fish to the PlayerInventory
		##var plant_instance = PlantScene.instantiate()
		PlayerManager.marineLifeInventory.append(plant)
		
		# Reload the UI
		UiManager.ReloadAllUI()
	else:
		Notifier.push_notification("YOU CANNOT AFFORD THIS")

## ReloadShopUI
## clears shop and adds current shop
## to it
func ReloadShopUI():		
	for child in $ShopScrollContainer/HBoxContainer.get_children():
		child.queue_free()
		
	# Reload the ShopStock items
	LoadShop()

## ReloadSellShopUI
## clears up sell shop and adds current inventory
## to the sell shop area
#func ReloadSellShopUI():
	## Clear existing children in the HBoxContainer
	#for child in $SellShopPanel/ScrollContainer/GridContainer.get_children():
		#child.queue_free()
		#
	## Reload the ShopStock items
	##LoadSellShop()

## ShowPlayerLevel
## gets player level and displays it
func ShowPlayerLevel():
	var LevelLabel = $LevelPanel/LevelLabel
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
	ShopStock.append({"texture": preload("res://assets/guppy.PNG"), "price": 1, "Species": ThEnums.FishSpecies.Guppy})
	PlantShopStock.append({"texture": preload("res://assets/guppyGrass.PNG"), "price": 1, "Species": ThEnums.PlantSpecies.Guppygrass})
	
		
	


func _on_inventory_pressed() -> void:
	if PlayerManager.marineLifeInventory.size() == 0:
		ShowShop()
		Notifier.push_notification("INVENTORY IS EMPTY")
	else:
		UiManager.ShowInventory()
		UiManager.CloseFishUI()
		UiManager.CloseTankCreationUI()
		CloseShop()


func _on_shop_pressed() -> void:
	ShowShop()
	
func CloseShop():
	$ShopScrollContainer.visible = false
	$Background.visible = false
	
func ShowInventorySort():
	$InventoryPanel.visible = true
	$SellPanel.visible = true
	
func CloseInventorySort():
	$InventoryPanel.visible = false
	$SellPanel.visible = false
	
func CloseMenuPanel():
	$Panel.visible = false
	$InventoryPanel.visible = false
	
func ShowMenuPanel():
	$Panel.visible = true
	$InventoryPanel.visible = true
	$SellPanel.visible = true
	
func ShowShop():
	UiManager.CloseInventory()
	UiManager.CloseFishUI()
	UiManager.CloseTankCreationUI()
	$ShopScrollContainer.visible = true
	$Background.visible = true
	
func FillFishPediaStartPage():
	var fishpedialist = []
	## fishpedialist.append({"type": "", "image": "","watertype": "", "harvesttime": "", "facts": ""})
	fishpedialist.append({"type": "Guppy", "image": "res://assets/guppy.PNG", "watertype": "Fresh", "harvesttime": "10 seconds", "facts": "Guppies are live bearers, which means they give birth to live young. Guppies enjoy being in groups."})
	fishpedialist.append({"type": "Guppy Grass", "image": "res://assets/guppyGrass.PNG","watertype": "Fresh", "harvesttime": "10 seconds", "facts": ""})
	if PlayerManager.level >= 5:
		fishpedialist.append({"type": "Clownfish", "image": "res://assets/clownfish.png","watertype": "Salt", "harvesttime": "", "facts": ""})
		fishpedialist.append({"type": "Anemone", "image": "res://assets/anemone.png","watertype": "Salt", "harvesttime": "", "facts": ""})
	
	var grid_container = $FishPediaStartPanel/GridContainer
	var details_panel = $DetailsPanel  # Reference to the single panel

	# Clear existing children in GridContainer
	for child in grid_container.get_children():
		child.queue_free()

	# Ensure the details panel is hidden initially
	if details_panel:
		details_panel.visible = false
		
	grid_container.columns = 4 # Adjust as needed
	grid_container.add_theme_constant_override("h_separation", 40)
	grid_container.add_theme_constant_override("v_separation", 40)

	# Add items to the GridContainer
	for item in fishpedialist:
		# Create a Button as the main clickable element
		var button = Button.new()
		button.flat = true  # Optional: Removes default button background
		button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER  # Changed to prevent over-expansion
		button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		button.custom_minimum_size = Vector2(100, 130)  # Smaller button size
		
		

		# Create a VBoxContainer to stack image and label
		var vbox = VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL

		# Create TextureRect for the image
		var texture_rect = TextureRect.new()
		texture_rect.texture = load(item.image)
		texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
		texture_rect.custom_minimum_size = Vector2(100, 100)  # Adjust size as needed

		# Create Label for the type
		var label = Label.new()
		label.text = item.type
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		# Add TextureRect and Label to VBoxContainer
		vbox.add_child(texture_rect)
		vbox.add_child(label)

		# Add VBoxContainer to Button
		button.add_child(vbox)

		# Connect button's pressed signal to show the panel with item details
		button.pressed.connect(func():
			show_details_panel(item, details_panel)
		)

		# Add Button to GridContainer
		grid_container.add_child(button)

# Function to show the details panel with the selected item's data
func show_details_panel(item: Dictionary, panel: Panel) -> void:
	$FishPediaStartPanel.visible = false
	if panel:
		# Update panel content
		$DetailsPanel/Name.text = item.type
		$DetailsPanel/Image.texture = load(item.image)
		$DetailsPanel/WaterTypeVariableLabel.text = item.watertype
		$DetailsPanel/HarvestTimeVariableLabel.text = item.harvesttime
		$DetailsPanel/InterestingFactsLabel.text = item.facts
		
		# Show the panel
		panel.visible = true


func _on_fish_pedia_back_button_pressed() -> void:
	$DetailsPanel.visible = false
	$FishPediaStartPanel.visible = true

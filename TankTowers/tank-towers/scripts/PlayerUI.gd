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
	var UpgradesPanel = $UpgradesPanel
	
	var BottomPanel = $Panel
	var menuButton = BottomPanel.get_node("Menu")
	#print(MenuPanel.visible)
	if MenuPanel && not MenuPanel.visible && not SettingsPanel.visible && not FishPeidaPanel.visible && not DetailsPanel.visible:
		MenuPanel.visible = true
		UpgradesPanel.visible = false
		menuButton.text = "X"
		menuButton.add_theme_stylebox_override("normal", create_stylebox(Color.RED))
		menuButton.add_theme_stylebox_override("hover", create_stylebox(Color.DARK_RED))
		menuButton.add_theme_stylebox_override("pressed", create_stylebox(Color.CRIMSON))
	else:
		MenuPanel.visible = false
		SettingsPanel.visible = false
		FishPeidaPanel.visible = false
		DetailsPanel.visible = false
		menuButton.text = "Menu"
		menuButton.remove_theme_stylebox_override("normal")
		menuButton.remove_theme_stylebox_override("hover")
		menuButton.remove_theme_stylebox_override("pressed")

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
		price.text = str(item.price, "$")
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
		price.text = str(item.price, "$")
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
			fish.sell_price = 5
			
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
			plant.sell_price = 10
		
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
	PlantShopStock.append({"texture": preload("res://assets/guppyGrass.PNG"), "price": 5, "Species": ThEnums.PlantSpecies.Guppygrass})
	
		
	


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
	
	var grid_container = $FishPediaStartPanel/ScrollContainer/GridContainer
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


func _on_worker_upgrade_purchase() -> void:
	if PlayerManager.money >= 50:
		var workerscene = load("res://scenes/Worker.tscn")
		var worker = workerscene.instantiate()
		worker.timetoharvest = 10
		get_tree().current_scene.add_child(worker)
		worker.makeWorkTimer()
		PlayerManager.workers.append(worker)
		PlayerManager.money -= 50
		upgrades()
	else:
		Notifier.push_notification("YOU CAN NOT AFFORD THIS")


func _on_upgrades_pressed() -> void:
	$UpgradesPanel.visible = !$UpgradesPanel.visible
	$MenuPanel.visible = false
	$SettingsPanel.visible = false
	$FishPediaStartPanel.visible = false
	$DetailsPanel.visible = false
	$Panel/Menu.remove_theme_stylebox_override("normal")
	$Panel/Menu.remove_theme_stylebox_override("hover")
	$Panel/Menu.remove_theme_stylebox_override("pressed")
	$Panel/Menu.text = "Menu"
	upgrades()
	
func create_stylebox(color: Color) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
	style.corner_radius_bottom_left = 5
	style.corner_radius_bottom_right = 5
	return style


func upgrades():
	var upgrades = []
	#upgrades.append({"title": "", "image": ,"desc": "", "price": , "func": })
	if $SellPanel/SellAllButton.visible == false:
		upgrades.append({"title": "Sell All", "image": "res://icon.svg","desc": "A new button that allows you to sell all in inventory", "price": 10, "func": Callable(self, "_on_sell_all_purchased") })
	upgrades.append({"title": "Worker", "image": "res://icon.svg","desc": "A worker will harvest fish and plants for you once every 10 seconds", "price": 50, "func": Callable(self, "_on_worker_upgrade_purchase")})
	if PlayerManager.unlockNursery == false:	
		upgrades.append({"title": "Nursery", "image": "res://icon.svg","desc": "Increase fish output to 4 fish per harvest", "price": 1000, "func": Callable(self, "_on_nursery_purchase")})
	
	var upgrade_container = $UpgradesPanel/VBoxContainer
	
	for child in upgrade_container.get_children():
		child.queue_free()
		
	var upgrades_scroll = ScrollContainer.new()
	upgrades_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	upgrades_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	upgrades_scroll.follow_focus = true
	upgrades_scroll.scroll_horizontal = false
	upgrades_scroll.scroll_vertical = true # Only horizontal scrolling
		
	# Create a Theme to hide the scrollbar
	var theme = Theme.new()
	# Set the scrollbar style to be invisible
	var empty_style = StyleBoxEmpty.new()
	theme.set_stylebox("scroll", "VScrollBar", empty_style)
	theme.set_stylebox("scroll", "HScrollBar", empty_style)
	upgrades_scroll.theme = theme
	
	var UpgradesVbox = VBoxContainer.new()
	UpgradesVbox.set("theme_override_constants/separation", 30)
	

	
	if PlayerManager.workers.size() >= 1:
		var scroll_container = ScrollContainer.new()
		scroll_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
		scroll_container.follow_focus = true
		scroll_container.scroll_horizontal = false
		scroll_container.scroll_vertical = true

		scroll_container.theme = theme

		var worker_container = VBoxContainer.new()
		worker_container.name = "WorkerContainer"
		worker_container.set("theme_override_constants/separation", 5)
		worker_container.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		
		for worker in PlayerManager.workers:
			var hbox = HBoxContainer.new()
			hbox.set("theme_override_constants/separation", 20)

			# Create TextureRect for the image
			var texture_rect = TextureRect.new()
			texture_rect.texture = load("res://icon.svg")
			texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
			texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
			texture_rect.size = Vector2(20,20)
			hbox.add_child(texture_rect)

			# Title
			var title_label = Label.new()
			title_label.text = "Worker"
			title_label.set("theme_override_font_sizes/font_size", 18)
			hbox.add_child(title_label)

			# Description
			var desc_label = Label.new()
			desc_label.text = "Decrease harvest to %d seconds" % (worker.timetoharvest - 1)
			if worker.level >= 10:
				desc_label.text = "Worker is Max Level"
			desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD
			desc_label.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
			desc_label.custom_minimum_size = Vector2(180, 0)
			hbox.add_child(desc_label)

			var workerHarvests = Label.new()
			workerHarvests.text = "Harvests: %d" % worker.harvestedMarineLife
			workerHarvests.set("theme_override_font_sizes/font_size", 18)
			hbox.add_child(workerHarvests)
			# Price
			var button = Button.new()
			button.text = "Price: %d" % (worker.level * 100)
			hbox.add_child(button)
			
			button.pressed.connect(worker.upgradeWorker)
			
			worker_container.add_child(hbox) # Add to worker_container, not scroll_container directly
	
		var workerLabel = Label.new()
		workerLabel.text = "Workers"
		workerLabel.set("theme_override_font_sizes/font_size", 20)
		scroll_container.add_child(worker_container)
		upgrade_container.add_child(workerLabel)
		upgrade_container.add_child(scroll_container)
	
	for upgrade in upgrades:
		
		var hbox = HBoxContainer.new()
		hbox.set("theme_override_constants/separation", 20)
		# Create TextureRect for the image
		var texture_rect = TextureRect.new()
		texture_rect.texture = load(upgrade.image)
		texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
		texture_rect.size = Vector2(20,20)
		hbox.add_child(texture_rect)
		
		# Title
		var title_label = Label.new()
		title_label.text = upgrade.title
		title_label.set("theme_override_font_sizes/font_size", 18)
		hbox.add_child(title_label)
		
		# Description
		var desc_label = Label.new()
		desc_label.text = upgrade.desc
		desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		desc_label.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		desc_label.custom_minimum_size = Vector2(300, 0) # Adjust width as needed
		hbox.add_child(desc_label)
		
		# Price
		var button = Button.new()
		button.text = "Buy: %d$" % upgrade.price
		hbox.add_child(button)
		
		
		button.pressed.connect(upgrade.func)
		
		UpgradesVbox.add_child(hbox)
	
	var upgradeLabel = Label.new()
	upgradeLabel.text = "Upgrades"
	upgradeLabel.set("theme_override_font_sizes/font_size", 20)
	upgrades_scroll.add_child(UpgradesVbox)
	upgrade_container.add_child(upgradeLabel)
	upgrade_container.add_child(upgrades_scroll)
		


func _on_sell_all_button_mouse_entered() -> void:
	var allSellMoney: int
	for item in PlayerManager.marineLifeInventory:
		allSellMoney += item.sell_price 
	
	$SellPanel/SellAllButton.text = "Sell All: %d" % allSellMoney


func _on_sell_all_button_mouse_exited() -> void:
	$SellPanel/SellAllButton.text = "Sell All" 


func _on_sell_all_button_pressed() -> void:
	$SellPanel/SellAllButton.text = "Sell All"
	
	for item in PlayerManager.marineLifeInventory:
		PlayerManager.money += item.sell_price
		item.queue_free()
		
	PlayerManager.marineLifeInventory = []
	UiManager.ReloadAllUI()

func _on_sell_all_purchased():
	if PlayerManager.money >= 10:
		$SellPanel/SellAllButton.visible = true
		PlayerManager.money -= 10
		upgrades()
	else:
		Notifier.push_notification("YOU CAN NOT AFFORD THIS")
		
		
func _on_nursery_purchase():
	if PlayerManager.money >= 1000:
		PlayerManager.unlockNursery = true
		PlayerManager.money -= 1000
		upgrades()
	else:
		Notifier.push_notification("YOU CAN NOT AFFORD THIS")

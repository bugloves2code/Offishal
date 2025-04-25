## Fish Friends
## Last Updated: 4/1/25 by Justin Ferreira
## UiManager Script
## This script is meant to hold all Ui elements to better manage
## each of them so all will be reloaded at the same time

extends Node

# Holder for the Player UI
var PlayerUI 

# Holder for Tank Drag Drop UI
var TankDragDrop

# Fish UI
var FishUI

#TankCreationUI
var TankCreationUI

var visibleDict = {
	0: null,
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
	7: null,
	8: null,
	9: null,
	10: null,
	11: null,
	12: null,
	13: null,
	14: null
}


var DontShowPlantYet = true
var ShowSellPanel = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerUI =  get_tree().get_root().get_node("Main/PlayerUI")
	#print(PlayerUI)
	TankDragDrop = get_tree().get_root().get_node("Main/DragDropMenu")
	FishUI = get_tree().get_root().get_node("Main/FishUI")
	TankCreationUI = get_tree().get_root().get_node("Main/TankCreationUI")
	CloseAllBottomUI()
	setNodesByStep()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
func setNodesByStep():
	visibleDict[0] = [get_tree().current_scene.get_node("Control/ScrollContainer/VBoxContainer/Control/CreateTankButton")]  # CreateTankButton
	visibleDict[1] = [PlayerUI.get_node("Panel"), PlayerUI.get_node("Panel/Shop")]  # Shop
	visibleDict[2] = [PlayerUI.get_node("Panel"), PlayerUI.get_node("Panel/Inventory")]  # Inventory
	visibleDict[3] = []  # No nodes
	visibleDict[4] = []  # PutInInventoryButton
	visibleDict[5] = [PlayerUI.get_node("Panel"), PlayerUI.get_node("Panel/Inventory"), PlayerUI.get_node("SellPanel")]  # Inventory, SellPanel
	visibleDict[6] = []  # No nodes
	visibleDict[7] = [PlayerUI.get_node("Panel"), PlayerUI.get_node("Panel/Shop"), PlayerUI.get_node("SellPanel")]  # Shop
	visibleDict[8] = [PlayerUI.get_node("Panel"),  PlayerUI.get_node("Panel/Inventory"), PlayerUI.get_node("SellPanel")]
	visibleDict[9] = [PlayerUI.get_node("Panel"),  PlayerUI.get_node("Panel/Inventory"), PlayerUI.get_node("SellPanel")]  # Inventory, SellPanel
	visibleDict[10] = [PlayerUI.get_node("Panel"),  PlayerUI.get_node("Panel/Inventory"), PlayerUI.get_node("SellPanel"), PlayerUI.get_node("Panel/Upgrades")]  # Upgrades
	visibleDict[11] = []  # Sell all (assuming upgrades button again)
	visibleDict[12] = []  # CreateTankButton, SaltwaterCheckBox
	visibleDict[13] = [] # Shop
	visibleDict[14] = [] 

## ReloadAllUI
## Takes every UI element that could possibly need a reload
## except for UI that is updated within their process function
## and give it a refresh so it is up to date with player experience
func ReloadAllUI():
	#PlayerUI.ReloadSellShopUI()
	PlayerUI.ReloadShopUI()
	PlayerUI.ShowPlayerLevel()
	TankDragDrop.populate_hbox_container()
	TankCreationUI.ReloadTankCreationUI()
	
## CloseAllFishUIBut
## closes all FishUI except the one passed
## used to make sure only one is open at a time
func CloseFishUI():
		if FishUI:
			FishUI.visible = false
			
func ShowTankCreationUI():
	TankCreationUI.visible = true
	
func CloseTankCreationUI():
	TankCreationUI.visible = false
	
func ShowInventory():
	#print("Called Show Inventory")
	if PlayerManager.marineLifeInventory.size() == 0:
		PlayerUI.ShowShop()
		Notifier.push_notification("INVENTORY IS EMPTY")
	else:
		TankDragDrop.visible = true
		if ShowSellPanel == true:
			PlayerUI.ShowInventorySort()
	
func CloseInventory():
	TankDragDrop.visible = false
	PlayerUI.CloseInventorySort()
	
func CloseShop():
	PlayerUI.CloseShop()
	
func CloseAllBottomUI():
	PlayerUI.CloseShop()
	TankDragDrop.visible = false
	CloseFishUI()
	PlayerUI.CloseInventorySort()
	PlayerUI.CloseMenuPanel()
	
func ShowAllBottomUI():
	PlayerUI.ShowMenuPanel()
	PlayerUI.CloseShop()
	ShowInventory()
	
func SaltWaterUnlock():
	TankCreationUI.SaltwaterCheckbox.visible = true
	
	
## Tutorital Hides and shows
func make_things_appear(step: int):
	if PlayerManager.tutorialComplete:
		PlayerUI.get_node("Panel/Menu").visible = true
		PlayerUI.get_node("Panel").visible = true
		get_tree().current_scene.get_node("Control/ScrollContainer/VBoxContainer/Control/CreateTankButton").visible = true
	if step == 7:
		DontShowPlantYet = false
		PlayerUI.StockShop()
	if step == 5:
		ShowSellPanel = true
	if step == 2:
		PlayerUI.get_node("Panel/Shop").visible = false
	if step == 1:
		get_tree().current_scene.get_node("Control/ScrollContainer/VBoxContainer/Control/CreateTankButton").visible = false
	for node in visibleDict[step]:
		node.visible = true

	

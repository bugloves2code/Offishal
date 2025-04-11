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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerUI =  get_tree().get_root().get_node("Main/PlayerUI")
	TankDragDrop = get_tree().get_root().get_node("Main/DragDropMenu")
	FishUI = get_tree().get_root().get_node("Main/FishUI")
	TankCreationUI = get_tree().get_root().get_node("Main/TankCreationUI")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
## ReloadAllUI
## Takes every UI element that could possibly need a reload
## except for UI that is updated within their process function
## and give it a refresh so it is up to date with player experience
func ReloadAllUI():
	PlayerUI.ReloadSellShopUI()
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

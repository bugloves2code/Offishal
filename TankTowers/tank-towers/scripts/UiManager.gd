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

# List of Fish UI that will be created
var FishUIs : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerUI =  get_tree().get_root().get_node("Main/PlayerUI")
	TankDragDrop = get_tree().get_root().get_node("Main/DragDropMenu")


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
	
## CloseAllFishUIBut
## closes all FishUI except the one passed
## used to make sure only one is open at a time
func CloseAllFishUIBut(fish_ui_instance : CanvasLayer):
	for FishUI in FishUIs:
		if FishUI != fish_ui_instance:
			FishUI.visible = false
			
## CloseAllFishUI
## which every FishUI is open will be closed
## this should only be one UI at a time
func CloseAllFishUI():
	for FishUI in FishUIs:
		FishUI.visible = false

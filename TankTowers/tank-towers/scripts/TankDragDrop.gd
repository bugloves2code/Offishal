## Fish Friends
## Last upadated 4/1/25 by Justin Ferreira
## TankDragDrop Script
## This decribes the UI that is used to drag and drop things
## into the tank

extends Control

# Load the DragDrop scene
var drag_drop_scene = preload("res://scenes/DragDrop.tscn")

# Reference to the HBoxContainer
@onready var hbox_container = $ScrollContainer/HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_hbox_container()


## populate_hbox_container
## Fills the Tank Drop UI with everything from marineLifeInventory
func populate_hbox_container():
	#Clear existing children in the HBoxContainer
	for child in hbox_container.get_children():
		child.queue_free()
	
	#Loop through the marineLifeInventory array
	for fish in PlayerManager.marineLifeInventory:
		#Instantiate the DragDrop scene
		var drag_drop_instance = drag_drop_scene.instantiate()
		
		#Access the Sprite2D node from the Fish Scene
		var fish_sprite = fish.get_node("Sprite2D")
		
		#Set the texture of the DragDrop scene to the fish's texture
		if fish_sprite and fish_sprite.texture:
			#print("Fish has get texture")
			drag_drop_instance.texture = fish_sprite.texture
		drag_drop_instance.drag_info = fish
			
		hbox_container.add_child(drag_drop_instance)
		

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
	# Clear existing children
	for child in hbox_container.get_children():
		child.queue_free()
	
	var species_dict = {}
	
	# Group fish by species
	for fish in PlayerManager.marineLifeInventory:
		var species = fish.Species
		
		if species in species_dict:
			species_dict[species].count += 1
		else:
			var fish_sprite = fish.get_node("Sprite2D")
			var texture = fish_sprite.texture if fish_sprite else null
			
			species_dict[species] = {
				"texture": texture,
				"drag_info": fish,
				"count": 1
			}
	
	# Create instances with counts
	for species_data in species_dict.values():
		var drag_drop_instance = drag_drop_scene.instantiate()
		
		# Set properties FIRST
		drag_drop_instance.texture = species_data.texture
		drag_drop_instance.drag_info = species_data.drag_info
		
		# Add to scene tree BEFORE setting count
		hbox_container.add_child(drag_drop_instance)
		
		# Now set count after the node is in the tree
		drag_drop_instance.count = species_data.count
		

## Fish Friends
## Last upadated 4/1/25 by Justin Ferreira
## DragDrop Script
## - This script describes how dragging
## and dropping information into containers
## works this script is used to properly
## have container which can give out 
## information when dragging something
## out of it and they are able to accept
## information aswell in certain circumstances
## all functions in this script are already in
## the Godot Libaries and has a lot of their
## functionality determined from the libaries

extends TextureRect

## drag_info
## this variable is used to store 
## the information being dragged
var drag_info: Node = null

## _get_drag_data
## This function is used to find
## the drag data it accepts the
## at_position parameter which helps
## it determine what infomation is 
## actually being dragged
## It also interacts with PlayerManger
## In order to keep track of when player
## is dragging
func _get_drag_data(_at_position):
	PlayerManager.is_dragging = true
	PlayerManager.current_dragged_item = drag_info
	
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = texture
	preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_texture.size = Vector2(30,30)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
	
	return drag_info
	
	
## _can_drop_data
## Check to make sure data
## is an accepted type
func _can_drop_data(_pos, data):
	#print("Checking if drop is allowed...")
	return data is Node

## _drop_data
## make sure data is used properly
## when drop is accepted. In this
## case it just makes the container
## use the texture of dropped item
func _drop_data(_pos, data):
	if data is TextureRect:
		texture = data.texture
		
## _notification
## notification is triggered when
## some things happen in Godot
## it is a pre made function from
## the Godot libaries. This notification
## makes it so that the player is not dragging
## and removes current dragged item.
func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		PlayerManager.is_dragging = false
		PlayerManager.current_dragged_item = null

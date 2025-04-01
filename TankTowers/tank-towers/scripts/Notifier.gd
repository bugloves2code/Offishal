## Fish Friends
## Last upadated 4/1/25 by Justin Ferreira
## Notifier Script
## - This script is a global that allows for
## notifications to be show to the player 

extends Node2D

## Variables to hold its nodes
var NotificationLabel: Label
var NotificationTimer: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## _enter_tree
## since this is a global not attached to any node
## this function allows for it to create nodes to use 
## one it is made a global in the project
func _enter_tree():
	# Create nodes programmatically
	NotificationLabel = Label.new()
	NotificationTimer = Timer.new()
	add_child(NotificationLabel)
	add_child(NotificationTimer)
	
	# Configure label
	NotificationLabel.visible = false
	NotificationLabel.z_index = 1
	
	NotificationLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	NotificationLabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	NotificationLabel.autowrap_mode = TextServer.AUTOWRAP_WORD
	NotificationLabel.custom_minimum_size = Vector2(400, 0) 
	
	var viewport_size = get_viewport_rect().size
	NotificationLabel.position = Vector2(
		viewport_size.x/2 - 200,  # Half width minus half label width
		viewport_size.y - 800       # 100 pixels from bottom
	)

## push_notification
## send a basic message to the player
func push_notification(text: String):
	NotificationLabel.text = text
	NotificationLabel.add_theme_color_override("font_color", Color.WHITE)  
	NotificationLabel.add_theme_font_size_override("font_size", 24)  # Larger font size
	NotificationLabel.visible = true
	
	NotificationLabel.reset_size()
	
	NotificationTimer.wait_time = 3
	NotificationTimer.start()
	await NotificationTimer.timeout
	NotificationLabel.visible = false
	
	

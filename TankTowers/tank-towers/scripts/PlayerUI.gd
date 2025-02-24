## Fish Friends
## Last upadated 2/21/25 by Justin Ferreira
## PlayerUI Script
## - This Script is used to display and 
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Panel/MoenyCount.text = str(PlayerManager.money)

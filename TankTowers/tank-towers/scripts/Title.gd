extends Node
signal gameStart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hiiiii")
	get_node("/root/Main/PlayerUI").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() 	-> void:
	self.visible = false
	get_node("/root/Main/PlayerUI").visible = true
	emit_signal("gameStart")

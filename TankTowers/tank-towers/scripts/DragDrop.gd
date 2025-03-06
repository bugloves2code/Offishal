extends TextureRect

var fish_instance: Node = null

func _get_drag_data(at_position):
	#print("Drag started! Fish instance: ", fish_instance)
	PlayerManager.is_dragging = true
	PlayerManager.current_dragged_item = fish_instance
	
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = texture
	preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_texture.size = Vector2(30,30)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
	
	return fish_instance
	
func _can_drop_data(_pos, data):
	#print("Checking if drop is allowed...")
	return data is Node
	
func _drop_data(_pos, data):
	if data is TextureRect:
		texture = data.texture
	else:
		print("Invalid drop: Data is not a TextureRect.")
		
func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		PlayerManager.is_dragging = false
		PlayerManager.current_dragged_item = null

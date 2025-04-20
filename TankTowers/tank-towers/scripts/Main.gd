extends Node
@export var tutorial_manager: NodePath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tutorial = get_node(tutorial_manager)
	tutorial.start_tutorial()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Node
@export var tutorial_manager: NodePath

var currentStep
var tutorial 
var glowNodes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tutorial = get_node(tutorial_manager)
	glowNodes = get_tree().get_nodes_in_group("Glodes")
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	##currentStep = tutorial.current_step
	pass

func setMaterial():
	for node in glowNodes:
		node.material.set_shader_parameter("onOff", 0.0)

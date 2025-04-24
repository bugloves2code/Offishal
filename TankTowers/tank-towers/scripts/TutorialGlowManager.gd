extends Node
@export var tutorial_manager: NodePath

var currentStep
var tutorial 
var glowNodes

var stepDict = {
	0: null,
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
	7: null,
	8: null,
	9: null,
	10: null,
	11: null,
	12: null,
	13: null,
	14: null
}

##CreateTankButton:<Button#61538829748>, createtank1  0
##PutinInventoryButton:<Button#61891151305>, put in inventory 1
##FreshWaterCheckBox:<CheckBox#62142809560>, freshwater checkbox 2
##SaltwaterCheckBox:<CheckBox#62193141211>, saltwater checkbox 3
##CreateTankButton:<Button#62277027296>, createtank2 4
##SellPanel:<Panel#63451432453>, dragto sell 5
## sell all button 6
##Shop:<Button#63753422359>, shop 7
##Upgrades:<Button#63803754010> upgrades 8
##Inventory:<Button#63854085661> inventory 9

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tutorial = get_node(tutorial_manager)
	glowNodes = get_tree().get_nodes_in_group("Glodes")
	setNodesByStep()

func setNodesByStep():
	stepDict[0] = [glowNodes[0], glowNodes[2], glowNodes[4]]  # CreateTankButton, FreshWaterCheckBox, CreateTankButton 2
	stepDict[1] = [glowNodes[7]]  # Shop
	stepDict[2] = [glowNodes[9]]  # Inventory
	stepDict[3] = []  # No nodes
	stepDict[4] = [glowNodes[1]]  # PutInInventoryButton
	stepDict[5] = [glowNodes[9], glowNodes[5]]  # Inventory, SellPanel
	stepDict[6] = []  # No nodes
	stepDict[7] = [glowNodes[7]]  # Shop
	stepDict[8] = []
	stepDict[9] = [glowNodes[9], glowNodes[5]]  # Inventory, SellPanel
	stepDict[10] = [glowNodes[8]]  # Upgrades
	stepDict[11] = [glowNodes[6]]  # Sell all (assuming upgrades button again)
	stepDict[12] = [glowNodes[0], glowNodes[3], glowNodes[4]]  # CreateTankButton, SaltwaterCheckBox
	stepDict[13] = [glowNodes[7]] # Shop
	stepDict[14] = []  # No nodes

 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	##currentStep = tutorial.current_step
	pass

func glow_nodes_for_step(step: int) -> void:
	turn_off_all_glow()
	#print(stepDict[step])
	for node in stepDict[step]:
		glow(node)

func create_stylebox(color: Color) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.border_color = Color.CYAN
	return box

func glow(node: Node) -> void:
	if node is Control:
		var stylebox := create_stylebox(Color.BLUE)
		if node is Button or node is CheckBox:
			node.add_theme_stylebox_override("normal", stylebox)
			node.add_theme_stylebox_override("hover", stylebox)
			node.add_theme_stylebox_override("pressed", stylebox)
		elif node is Panel:
			node.add_theme_stylebox_override("panel", stylebox)

func turn_off_all_glow() -> void:
	for node in glowNodes:
		if node is Control:
			if node is Button or node is CheckBox:
				node.remove_theme_stylebox_override("normal")
				node.remove_theme_stylebox_override("hover")
				node.remove_theme_stylebox_override("pressed")
			elif node is Panel:
				node.remove_theme_stylebox_override("panel")

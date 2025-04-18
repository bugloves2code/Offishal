extends Node

@export var tutorial_overlay: NodePath

var overlay
var steps: Array[TutorialStep] = []
var current_step := 0
var waiting_for_action := false
signal tutorial_complete

func _ready():
	##print("Overlay path:", tutorial_overlay)
	##print("Overlay resolved:", get_node_or_null(tutorial_overlay))
	
	overlay = get_node("/root/Main/TutorialCharacter")
	##print(overlay)
	overlay.connect("tutorial_continue", Callable(self, "_on_tutorial_acknowledged"))

#func _process(delta: float) -> void:
	#print(waiting_for_action)
	#print(current_step)

func start_tutorial():
	create_tutorial_steps()
	current_step = 0
	_start_step()

func create_tutorial_steps():
	var step1 = TutorialStep.new()
	step1.instruction_text = "Welcome to Tank Towers! Try creating a new Freshwater Tank to get started."
	step1.signal_name = "tankAdded"
	step1.signal_source = "/root/TankManager"
	steps.append(step1)
	
	var step2 = TutorialStep.new()
	step2.instruction_text = "Great now try to drag a fish into your new Tank!"
	step2.signal_name = "addFish"
	step2.signal_source = ""
	steps.append(step2)
	
	var step3 = TutorialStep.new()
	step3.instruction_text = "Your fish is ready to harvest when it turns blue. Simply tap the fish. Try it out!"
	step3.signal_name = "fishClicked"
	step3.signal_source = ""
	steps.append(step3)
	
	var step4 = TutorialStep.new()
	step4.instruction_text = "Let's try to buy more fish and plants. Click on the shop to buy more fish."
	step4.signal_name = "shopClick"
	step4.signal_source = ""
	steps.append(step4)
	
	

func _start_step():
	##print(current_step)
	var step = steps[current_step]  
	overlay.show_tutorial(step.instruction_text)
	waiting_for_action = false
	#var source = get_node(step.signal_source) 
	#source.connect(step.signal_name, Callable(self, "_on_step_completed")) 

func _on_tutorial_acknowledged():
	if waiting_for_action:
		return
	overlay.hide_tutorial()
	
	waiting_for_action = true
	if current_step >= steps.size():
		print(current_step, steps.size())
		emit_signal("tutorial_complete")
		return
	#print(steps[1].signal_name)
	#print(steps[1].signal_source)
	var step = steps[current_step]
	var source = get_node(step.signal_source)
	##print(step.signal_name, step.signal_source)
	source.connect(step.signal_name, Callable(self, "_on_step_completed"))
	if source.is_connected(step.signal_name, Callable(self, "_on_step_completed")):
		print("connected!")

func _on_step_completed():
	##print("step completed")
	var step = steps[current_step]
	var source = get_node(step.signal_source)
	if source.is_connected(step.signal_name, Callable(self, "_on_step_completed")):
		source.disconnect(step.signal_name, Callable(self, "_on_step_completed"))
	
	current_step += 1
	if (current_step == 1):
		var tankPath = TankManager.tankList[0].get_path()
		print(TankManager.tankList[0])
		steps[1].signal_source = tankPath
		##TankManager.tankList[0].connect("addFish", Callable(self, "_on_step_completed"))
		##print(steps[1].signal_source)
	if (current_step == 2):
		var fishPath = TankManager.tankList[0].fishList[0].get_path()
		steps[2].signal_source = fishPath

	if current_step < steps.size():
		overlay.show_tutorial(steps[current_step].instruction_text)
		waiting_for_action = false
		##_start_step()
	else:
		emit_signal("tutorial_complete")

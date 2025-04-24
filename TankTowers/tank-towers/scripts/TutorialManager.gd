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
	##done 0
	var step1 = TutorialStep.new()
	step1.instruction_text = "Create a Tank to get started! Click the checkmark next to Freshwater Tank in the menu."
	step1.signal_name = "tankAdded"
	step1.signal_source = "/root/TankManager"
	steps.append(step1)

	##done 1 PLAYERUI
	var step2 = TutorialStep.new()
	step2.instruction_text = "Now buy a fish from the shop!"
	step2.signal_name = "buyFish"
	steps.append(step2)

	##done 2 TANK
	var step3 = TutorialStep.new()
	step3.instruction_text = "Go to your inventory and drag in your new fish."
	step3.signal_name = "addFish"
	steps.append(step3)
	
	##done 3 FISH
	var step4 = TutorialStep.new()
	step4.instruction_text = "When your fish is ready to harvest, it will turn blue. Press it when it does!"
	step4.signal_name = "fishClicked"
	steps.append(step4)

	##done 4 FISH UI
	var step5 = TutorialStep.new()
	step5.instruction_text = "Nice job! Now you have more fish. You can add these to your inventory to sell — this is how you make money."
	step5.signal_name = "fishAddedToInventory"
	step5.signal_source = UiManager.FishUI.get_path()
	steps.append(step5)

	##done 5 SELLPANEL
	var step6 = TutorialStep.new()
	step6.instruction_text = "At the top of your screen, there should be a drag-to-sell area. Try selling your fish!"
	step6.signal_name = "fishSold"
	##step6.signal_source = get_node("/root/UiManager/PlayerUI/SellPanel").get_path()
	steps.append(step6)

	##done 6 FISH
	var step7 = TutorialStep.new()
	step7.instruction_text = "Great! Now try to fill the tank. You’ll know it’s full when fish are added to your inventory automatically."
	step7.signal_name = "tankAutoFilled"
	steps.append(step7)

	##done 7 PLAYERUI
	var step8 = TutorialStep.new()
	step8.instruction_text = "Okay, let's try buying a plant now."
	step8.signal_name = "buyPlant"
	steps.append(step8)

	##done 8 TANK
	var step9 = TutorialStep.new()
	step9.instruction_text = "Sweet! Now add the plant to your tank."
	step9.signal_name = "addPlant"
	steps.append(step9)

	##done 9 SELLPANEL
	var step10 = TutorialStep.new()
	step10.instruction_text = "Plants and fish help each other — more fish means faster plant growth. Try selling a plant too!"
	step10.signal_name = "plantSold"
	##step10.signal_source = get_node("/root/UiManager/PlayerUI/SellPanel").get_path()
	steps.append(step10)

	##done 10 PLAYER UI
	var step11 = TutorialStep.new()
	step11.instruction_text = "Let’s talk about upgrades! Tap the upgrades button to buy enhancements. Try purchasing the Sell All upgrade."
	step11.signal_name = "sellAllPurchased"
	steps.append(step11)

	##done 11 PLAYERMANAGER
	var step12 = TutorialStep.new()
	step12.instruction_text = "Now when you access your inventory, you can sell everything instantly!"
	step12.signal_name = "reachLevel5"
	steps.append(step12)

	## done 12 TANK
	var step13 = TutorialStep.new()
	step13.instruction_text = "You reached level 5! Now you can buy Saltwater Tanks and new fish and plants. Try adding them to your collection!"
	step13.signal_name = "addClownFish"
	steps.append(step13)

	## 13 TANK
	var step14 = TutorialStep.new()
	step14.instruction_text = "Great! You’ve completed the tutorial for Tank Towers. Keep expanding your marine collection and check the shop often. Good luck, fish friend!"
	##step14.signal_name = "tutorialComplete"
	steps.append(step14)

	#var step1 = TutorialStep.new()
	#step1.instruction_text = "Welcome to Tank Towers! My name is Professor Marlin. Try creating a new Freshwater Tank to get started."
	#step1.signal_name = "tankAdded"
	#step1.signal_source = "/root/TankManager"
	#steps.append(step1)
	#
	#var step2 = TutorialStep.new()
	#step2.instruction_text = "Great now try to drag a fish into your new Tank!"
	#step2.signal_name = "addFish"
	#steps.append(step2)
	#
	#var step3 = TutorialStep.new()
	#step3.instruction_text = "Your fish is ready to harvest when it turns blue. Simply tap the fish. Try it out!"
	#step3.signal_name = "fishClicked"
	#steps.append(step3)
	#
	#var step4 = TutorialStep.new()
	#step4.instruction_text = "Let's try to buy more fish and plants. Click on the shop to buy more fish."
	#step4.signal_name = "shopPressed"
	#steps.append(step4)
	#
	#var step5 = TutorialStep.new()
	#step5.instruction_text = "Now that you bought more fish, keep harvesting to get more money. Then you can buy more tanks, fish and level up to unlock more types of fish. Good Luck!"
	#steps.append(step5)

func _start_step():
	##print(current_step)
	var step = steps[current_step]  
	overlay.show_tutorial(step.instruction_text)
	waiting_for_action = false
	
	#var source = get_node(step.signal_source) 
	#source.connect(step.signal_name, Callable(self, "_on_step_completed")) 

func _on_tutorial_acknowledged():
	if waiting_for_action:
		print("Waiting for action")
		return
	overlay.hide_tutorial()
	print("Tutorial Acknowledged")
	UiManager.ShowAllBottomUI()
	waiting_for_action = true
	if current_step >= steps.size()-1:
		emit_signal("tutorial_complete")
		return
	#print(steps[1].signal_name)
	#print(steps[1].signal_source)
	var step = steps[current_step]
	var source = get_node(step.signal_source)
	source.connect(step.signal_name, Callable(self, "_on_step_completed"))
	if source.is_connected(step.signal_name, Callable(self, "_on_step_completed")):
		print("connected!")

func _on_step_completed():
	print("step completed")
	UiManager.CloseAllBottomUI()
	var step = steps[current_step]
	var source = get_node(step.signal_source)
	if source.is_connected(step.signal_name, Callable(self, "_on_step_completed")):
		source.disconnect(step.signal_name, Callable(self, "_on_step_completed"))
	
	current_step += 1
	if (current_step == 2): #TANK
		var tankPath = TankManager.tankList[0].get_path()
		#print(TankManager.tankList[0])
		steps[2].signal_source = tankPath
		steps[8].signal_source = tankPath
		steps[12].signal_source = tankPath
		##TankManager.tankList[0].connect("addFish", Callable(self, "_on_step_completed"))
		##print(steps[1].signal_source)
	if (current_step == 3): #FISH
		var fishPath = TankManager.tankList[0].fishList[0].get_path()
		steps[3].signal_source = fishPath
	if (current_step == 6):
		var tankPath = TankManager.tankList[0].get_path()
		steps[6].signal_source = tankPath
	if (current_step == 1): #PLAYERUI
		var shopPath = UiManager.PlayerUI.get_path()
		steps[1].signal_source = shopPath
		steps[7].signal_source = shopPath
		steps[10].signal_source = shopPath
		steps[11].signal_source = shopPath
	if (current_step == 5): #SELLPANEL
		var sellPath = UiManager.PlayerUI.get_node("SellPanel/Control").get_path()
		steps[5].signal_source = sellPath
		print(steps[5].signal_source)
		steps[9].signal_source = sellPath
	if current_step == 11:
		steps[11].signal_source = PlayerManager.get_path()
		if (PlayerManager.is_connected(steps[11].signal_name, Callable(self, "_on_step_completed"))):
			print("connect!")
	if current_step == 12:
		var tankPath = TankManager.tankList[0].get_path()
		steps[12].signal_source = tankPath
	if current_step < steps.size():
		overlay.show_tutorial(steps[current_step].instruction_text)
		waiting_for_action = false
		##_start_step()
	else:
		emit_signal("tutorial_complete")
		PlayerManager.tutoialComplete = true

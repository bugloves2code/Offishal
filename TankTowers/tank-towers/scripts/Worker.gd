extends Node

var timetoharvest

var timer: Timer

var selectedtank
var checkedtankslist = []
var checkedfishlist = []
var checkedplantlist = []

var level = 1

var harvestedMarineLife = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = Timer.new()
	timer.name = "WorkTimer"
	add_child(timer)
	timer.autostart = false  # Prevent starting until configured
	makeWorkTimer()  # Set up the timer on ready


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func work():		
	if TankManager.tankList.is_empty():
		return
	
	if selectedtank == null:
		selectedtank = TankManager.tankList[0]
		checkedtankslist.append(selectedtank)
	if checkedfishlist == selectedtank.fishList:
		if checkedplantlist == selectedtank.plantList:
			if checkedtankslist == TankManager.tankList:
				checkedtankslist = []
				checkedfishlist = []
				checkedplantlist = []
				selectedtank = TankManager.tankList[0]
			else:
				for tank in TankManager.tankList:
					if tank not in checkedtankslist:
						checkedfishlist = []
						checkedplantlist = []
						selectedtank = tank
						checkedtankslist.append(selectedtank)
						return
		else:
			for plant in selectedtank.plantList:
				if plant.harvestStatus == true:
					if plant not in checkedplantlist:
						checkedplantlist.append(plant)
						if plant.harvestStatus == true:
							plant.get_node("Sprite2D").material.set_shader_parameter("onOff", 0.0);
							plant.get_node("Harvest").start()
							plant.harvestStatus = false
							
							
							if plant.Species == ThEnums.PlantSpecies.Guppygrass:
								if PlayerManager.unlockFertilizer:
									if PlayerManager.unlockAutoSell:
										PlayerManager.xp += 2
										PlayerManager.money += 2
										harvestedMarineLife += 1
										return
									PlayerManager.xp += 2
									PlayerManager.marineLifeInventory.append(load("res://scenes/Plant.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/Plant.tscn").instantiate())
									harvestedMarineLife += 1
									UiManager.TankDragDrop.populate_hbox_container()
									return
								if PlayerManager.unlockAutoSell:
									PlayerManager.xp += 1
									PlayerManager.money += 1
									harvestedMarineLife += 1
									return
								PlayerManager.xp += 1
								PlayerManager.marineLifeInventory.append(load("res://scenes/Plant.tscn").instantiate())
								harvestedMarineLife += 1
								UiManager.TankDragDrop.populate_hbox_container()
								
								
							if plant.Species == ThEnums.PlantSpecies.Coral:
								if PlayerManager.unlockFertilizer:
									if PlayerManager.unlockAutoSell:
										PlayerManager.xp += 200
										PlayerManager.money += 200
										harvestedMarineLife += 1
										return
									PlayerManager.xp += 200
									PlayerManager.marineLifeInventory.append(load("res://scenes/Coral.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/Coral.tscn").instantiate())
									harvestedMarineLife += 1
									UiManager.TankDragDrop.populate_hbox_container()
									return
								if PlayerManager.unlockAutoSell:
									PlayerManager.xp += 100
									PlayerManager.money += 100
									harvestedMarineLife += 1
									return
								PlayerManager.xp += 100
								PlayerManager.marineLifeInventory.append(load("res://scenes/Coral.tscn").instantiate())
								harvestedMarineLife += 1
								UiManager.TankDragDrop.populate_hbox_container()
								
								
							elif plant.Species == ThEnums.PlantSpecies.Anemone:
								if PlayerManager.unlockFertilizer:
									if PlayerManager.unlockAutoSell:
										PlayerManager.xp += 6
										PlayerManager.money += 20
										harvestedMarineLife += 1
										return
									PlayerManager.xp += 6
									PlayerManager.marineLifeInventory.append(load("res://scenes/Anemone.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/Anemone.tscn").instantiate())
									harvestedMarineLife += 1
									UiManager.TankDragDrop.populate_hbox_container()
									return
								if PlayerManager.unlockAutoSell:
									PlayerManager.xp += 3
									PlayerManager.money += 10
									harvestedMarineLife += 1
									return
								PlayerManager.xp += 3
								PlayerManager.marineLifeInventory.append(load("res://scenes/Anemone.tscn").instantiate())
								harvestedMarineLife += 1
								UiManager.TankDragDrop.populate_hbox_container()
						return
				else:
					if plant not in checkedplantlist:
						checkedplantlist.append(plant)
	else:
		for fish in selectedtank.fishList:
			if fish.harvestStatus == true:
				if fish not in checkedfishlist:
					checkedfishlist.append(fish)
					if fish.harvestStatus == true:
						fish.get_node("Sprite2D").material.set_shader_parameter("onOff", 0.0);
						fish.get_node("Harvest").start()
						fish.harvestStatus = false
						if fish.Species == ThEnums.FishSpecies.Guppy:
							if PlayerManager.unlockNursery == true:
								if PlayerManager.unlockAutoSell:
									PlayerManager.xp += 4
									PlayerManager.money += 4
									harvestedMarineLife += 1
									return
								if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
									fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
									PlayerManager.xp += 1
									if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
										fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
										PlayerManager.xp += 1
										if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
											fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
											PlayerManager.xp += 1
											if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
												fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
												harvestedMarineLife += 1
												PlayerManager.xp += 1
											else:
												PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
												UiManager.TankDragDrop.populate_hbox_container()
												harvestedMarineLife += 1
												PlayerManager.xp += 1
										else:
											PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
											PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
											UiManager.TankDragDrop.populate_hbox_container()
											harvestedMarineLife += 1
											PlayerManager.xp += 2
									else:
										PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
										PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
										PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
										UiManager.TankDragDrop.populate_hbox_container()
										harvestedMarineLife += 1
										PlayerManager.xp += 3
										
								else:
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									UiManager.TankDragDrop.populate_hbox_container()
									harvestedMarineLife += 1
									PlayerManager.xp += 4
								return
							if PlayerManager.unlockAutoSell:
									PlayerManager.xp += 2
									PlayerManager.money += 2
									harvestedMarineLife += 1
									return
							if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
								fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
								PlayerManager.xp += 2
								UiManager.TankDragDrop.populate_hbox_container()
								if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
									fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
								else:
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									UiManager.TankDragDrop.populate_hbox_container()
									PlayerManager.xp += 1
									harvestedMarineLife += 1
							else:
								PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
								UiManager.TankDragDrop.populate_hbox_container()
								PlayerManager.xp += 1
								harvestedMarineLife += 1
								
								
						elif fish.Species == ThEnums.FishSpecies.BlueTang:
							if PlayerManager.unlockNursery == true:
								if PlayerManager.unlockAutoSell:
									PlayerManager.xp += 400
									PlayerManager.money += 400
									harvestedMarineLife += 1
									return
								if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
									fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
									PlayerManager.xp += 100
									if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
										fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
										PlayerManager.xp += 100
										if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
											fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
											PlayerManager.xp += 100
											if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
												fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
												harvestedMarineLife += 1
												PlayerManager.xp += 100
											else:
												PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
												UiManager.TankDragDrop.populate_hbox_container()
												harvestedMarineLife += 1
												PlayerManager.xp += 100
										else:
											PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
											PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
											UiManager.TankDragDrop.populate_hbox_container()
											harvestedMarineLife += 1
											PlayerManager.xp += 200
									else:
										PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
										PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
										PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
										UiManager.TankDragDrop.populate_hbox_container()
										harvestedMarineLife += 1
										PlayerManager.xp += 300
										
								else:
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									UiManager.TankDragDrop.populate_hbox_container()
									harvestedMarineLife += 1
									PlayerManager.xp += 400
								return
							if PlayerManager.unlockAutoSell:
									PlayerManager.xp += 200
									PlayerManager.money += 200
									harvestedMarineLife += 1
									return
							if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
								fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
								PlayerManager.xp += 200
								UiManager.TankDragDrop.populate_hbox_container()
								if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
									fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
								else:
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									UiManager.TankDragDrop.populate_hbox_container()
									PlayerManager.xp += 100
									harvestedMarineLife += 1
							else:
								PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
								UiManager.TankDragDrop.populate_hbox_container()
								PlayerManager.xp += 100
								harvestedMarineLife += 1
								
								
						elif fish.Species == ThEnums.FishSpecies.Pike:
							if PlayerManager.unlockNursery == true:
								if PlayerManager.unlockAutoSell:
									PlayerManager.xp += 200
									PlayerManager.money += 200
									harvestedMarineLife += 1
									return
								if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
									fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
									PlayerManager.xp += 50
									if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
										fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
										PlayerManager.xp += 50
										if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
											fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
											PlayerManager.xp += 50
											if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
												fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
												harvestedMarineLife += 1
												PlayerManager.xp += 50
											else:
												PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
												UiManager.TankDragDrop.populate_hbox_container()
												harvestedMarineLife += 1
												PlayerManager.xp += 50
										else:
											PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
											PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
											UiManager.TankDragDrop.populate_hbox_container()
											harvestedMarineLife += 1
											PlayerManager.xp += 100
									else:
										PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
										PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
										PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
										UiManager.TankDragDrop.populate_hbox_container()
										harvestedMarineLife += 50
										PlayerManager.xp += 150
										
								else:
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									UiManager.TankDragDrop.populate_hbox_container()
									harvestedMarineLife += 1
									PlayerManager.xp += 200
								return
							if PlayerManager.unlockAutoSell:
									PlayerManager.xp += 100
									PlayerManager.money += 100
									harvestedMarineLife += 1
									return
							if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
								fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
								PlayerManager.xp += 100
								UiManager.TankDragDrop.populate_hbox_container()
								if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
									fish.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
								else:
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									UiManager.TankDragDrop.populate_hbox_container()
									PlayerManager.xp += 50
									harvestedMarineLife += 1
							else:
								PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
								UiManager.TankDragDrop.populate_hbox_container()
								PlayerManager.xp += 50
								harvestedMarineLife += 1
								
								
						elif fish.Species == ThEnums.FishSpecies.Clownfish:
							if PlayerManager.unlockNursery == true:
								if PlayerManager.unlockAutoSell:
									PlayerManager.xp += 20
									PlayerManager.money += 20
									harvestedMarineLife += 1
									return
								if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
									fish.get_parent().AddFish(load("res://scenes/ClownFish.tscn").instantiate())
									PlayerManager.xp += 5
									if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
										fish.get_parent().AddFish(load("res://scenes/ClownFish.tscn").instantiate())
										PlayerManager.xp += 5
										if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
											fish.get_parent().AddFish(load("res://scenes/ClownFish.tscn").instantiate())
											PlayerManager.xp += 5
											if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
												fish.get_parent().AddFish(load("res://scenes/ClownFish.tscn").instantiate())
												harvestedMarineLife += 1
												PlayerManager.xp += 5
											else:
												PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
												UiManager.TankDragDrop.populate_hbox_container()
												harvestedMarineLife += 1
												PlayerManager.xp += 5
										else:
											PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
											PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
											UiManager.TankDragDrop.populate_hbox_container()
											harvestedMarineLife += 1
											PlayerManager.xp += 10
									else:
										PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
										PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
										PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
										UiManager.TankDragDrop.populate_hbox_container()
										harvestedMarineLife += 1
										PlayerManager.xp += 15
										
								else:
									PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
									UiManager.TankDragDrop.populate_hbox_container()
									harvestedMarineLife += 1
									PlayerManager.xp += 20
								return
							if PlayerManager.unlockAutoSell:
									PlayerManager.xp += 10
									PlayerManager.money += 10
									harvestedMarineLife += 1
									return
							if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
								fish.get_parent().AddFish(load("res://scenes/ClownFish.tscn").instantiate())
								PlayerManager.xp += 5
								harvestedMarineLife += 1
								if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
									fish.get_parent().AddFish(load("res://scenes/ClownFish.tscn").instantiate())
								else:
									PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
									UiManager.TankDragDrop.populate_hbox_container()
									PlayerManager.xp += 1
									harvestedMarineLife += 1
							else:
								PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
								UiManager.TankDragDrop.populate_hbox_container()
								PlayerManager.xp += 1
								harvestedMarineLife += 1
					return
			else:
				if fish not in checkedfishlist:
					checkedfishlist.append(fish)
				if checkedfishlist == selectedtank.fishList:
					if checkedplantlist == selectedtank.plantList:
						if checkedtankslist == TankManager.tankList:
							checkedtankslist = []
							checkedfishlist = []
							checkedplantlist = []
							selectedtank = TankManager.tankList[0]
						else:
							for tank in TankManager.tankList:
								if tank not in checkedtankslist:
									checkedfishlist = []
									checkedplantlist = []
									selectedtank = tank
									checkedtankslist.append(selectedtank)
									return
					else:
						for plant in selectedtank.plantList:
							if plant.harvestStatus == true:
								if plant not in checkedplantlist:
									checkedplantlist.append(plant)
									if plant.harvestStatus == true:
										plant.get_node("Sprite2D").material.set_shader_parameter("onOff", 0.0);
										plant.get_node("Harvest").start()
										plant.harvestStatus = false
										if plant.Species == ThEnums.PlantSpecies.Guppygrass:
											if PlayerManager.unlockFertilizer:
												if PlayerManager.unlockAutoSell:
													PlayerManager.xp += 2
													PlayerManager.money += 2
													harvestedMarineLife += 1
													return
												PlayerManager.xp += 2
												PlayerManager.marineLifeInventory.append(load("res://scenes/Plant.tscn").instantiate())
												PlayerManager.marineLifeInventory.append(load("res://scenes/Plant.tscn").instantiate())
												harvestedMarineLife += 1
												UiManager.TankDragDrop.populate_hbox_container()
												return
											if PlayerManager.unlockAutoSell:
												PlayerManager.xp += 1
												PlayerManager.money += 1
												harvestedMarineLife += 1
												return
											PlayerManager.xp += 1
											PlayerManager.marineLifeInventory.append(load("res://scenes/Plant.tscn").instantiate())
											harvestedMarineLife += 1
											UiManager.TankDragDrop.populate_hbox_container()
											
											
											if plant.Species == ThEnums.PlantSpecies.Coral:
												if PlayerManager.unlockFertilizer:
													if PlayerManager.unlockAutoSell:
														PlayerManager.xp += 200
														PlayerManager.money += 200
														harvestedMarineLife += 1
														return
													PlayerManager.xp += 200
													PlayerManager.marineLifeInventory.append(load("res://scenes/Coral.tscn").instantiate())
													PlayerManager.marineLifeInventory.append(load("res://scenes/Coral.tscn").instantiate())
													harvestedMarineLife += 1
													UiManager.TankDragDrop.populate_hbox_container()
													return
												if PlayerManager.unlockAutoSell:
													PlayerManager.xp += 100
													PlayerManager.money += 100
													harvestedMarineLife += 1
													return
												PlayerManager.xp += 100
												PlayerManager.marineLifeInventory.append(load("res://scenes/Coral.tscn").instantiate())
												harvestedMarineLife += 1
												UiManager.TankDragDrop.populate_hbox_container()
											
											
										elif plant.Species == ThEnums.PlantSpecies.Anemone:
											if PlayerManager.unlockFertilizer:
												if PlayerManager.unlockAutoSell:
													PlayerManager.xp += 6
													PlayerManager.money += 20
													harvestedMarineLife += 1
													return
												PlayerManager.xp += 6
												PlayerManager.marineLifeInventory.append(load("res://scenes/Anemone.tscn").instantiate())
												PlayerManager.marineLifeInventory.append(load("res://scenes/Anemone.tscn").instantiate())
												harvestedMarineLife += 1
												UiManager.TankDragDrop.populate_hbox_container()
												return
											if PlayerManager.unlockAutoSell:
												PlayerManager.xp += 3
												PlayerManager.money += 10
												harvestedMarineLife += 1
												return
											PlayerManager.xp += 3
											PlayerManager.marineLifeInventory.append(load("res://scenes/Anemone.tscn").instantiate())
											harvestedMarineLife += 1
											UiManager.TankDragDrop.populate_hbox_container()
									return
							else:
								if plant not in checkedplantlist:
									checkedplantlist.append(plant)
	
	
	
func makeWorkTimer():
	if timer:
		# Stop the timer if already running
		timer.stop()

		# Configure the timer
		timer.wait_time = max(timetoharvest, 0.1)  # Ensure non-zero wait_time
		timer.one_shot = false  # Repeat indefinitely
		timer.autostart = true  # Start automatically

		# Disconnect existing connections to avoid duplicates
		if timer.timeout.is_connected(work):
			timer.timeout.disconnect(work)

		# Connect the timeout signal to work
		timer.timeout.connect(work)
		timer.start()

		# Debug
	else:
		push_error("Timer not initialized")
		
func upgradeWorker():
	if level >= 10:
		Notifier.push_notification("THIS WORKER IS MAX LEVEL")
		return
	if PlayerManager.money >= level * 100:
		PlayerManager.money -= level * 100
		level += 1
		timetoharvest = 11 - level
		UiManager.PlayerUI.upgrades()
		makeWorkTimer()

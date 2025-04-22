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
								PlayerManager.xp += 1
								var plantscene = load("res://scenes/Plant.tscn").instantiate()
								plantscene.Species = ThEnums.PlantSpecies.Guppygrass
								PlayerManager.marineLifeInventory.append(plantscene)
								harvestedMarineLife += 1
								UiManager.TankDragDrop.populate_hbox_container()
							elif plant.Species == ThEnums.PlantSpecies.Anemone:
								PlayerManager.xp += 3
								var plantscene = load("res://scenes/Anemone.tscn").instantiate()
								plantscene.Species = ThEnums.PlantSpecies.Anemone
								PlayerManager.marineLifeInventory.append(plantscene)
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
						var fishScene
						if fish.Species == ThEnums.FishSpecies.Guppy:
							fishScene = load("res://scenes/Fish.tscn").instantiate()
							fishScene.Species = ThEnums.FishSpecies.Guppy
							if PlayerManager.unlockNursery == true:
								PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
								PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
								PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
								PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
								UiManager.TankDragDrop.populate_hbox_container()
								harvestedMarineLife += 1
								PlayerManager.xp += 4
								return
							if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
								fish.get_parent().AddFish(fishScene)
								PlayerManager.xp += 2
								harvestedMarineLife += 1
								if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
									fish.get_parent().AddFish(fishScene)
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
						elif fish.Species == ThEnums.FishSpecies.Clownfish:
							fishScene = load("res://scenes/ClownFish.tscn").instantiate()
							fishScene.Species = ThEnums.FishSpecies.Clownfish
							if PlayerManager.unlockNursery == true:
								PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
								PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
								PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
								PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
								UiManager.TankDragDrop.populate_hbox_container()
								harvestedMarineLife += 1
								PlayerManager.xp += 20
								return
							if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
								fish.get_parent().AddFish(fishScene)
								PlayerManager.xp += 5
								harvestedMarineLife += 1
								if fish.get_parent().fishList.size() < fish.get_parent().fishCapacity:
									fish.get_parent().AddFish(fishScene)
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
						fishScene = null
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
											PlayerManager.xp += 1
											var plantscene = load("res://scenes/Plant.tscn").instantiate()
											plantscene.Species = ThEnums.PlantSpecies.Guppygrass
											PlayerManager.marineLifeInventory.append(plantscene)
											harvestedMarineLife += 1
											UiManager.TankDragDrop.populate_hbox_container()
										elif plant.Species == ThEnums.PlantSpecies.Anemone:
											PlayerManager.xp += 3
											var plantscene = load("res://scenes/Anemone.tscn").instantiate()
											plantscene.Species = ThEnums.PlantSpecies.Anemone
											PlayerManager.marineLifeInventory.append(plantscene)
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

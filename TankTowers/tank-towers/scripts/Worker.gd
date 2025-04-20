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
				if plant not in checkedplantlist:
					checkedplantlist.append(plant)
					if plant.harvestStatus == true:
						plant.get_node("Sprite2D").material.set_shader_parameter("onOff", 0.0);
						plant.get_node("Harvest").start()
						plant.harvestStatus = false
						if plant.Species == ThEnums.PlantSpecies.Guppygrass:
							PlayerManager.xp += 1
							PlayerManager.money += 1
						elif plant.Species == ThEnums.PlantSpecies.Anemone:
							PlayerManager.xp += 3
							PlayerManager.money += 3
						harvestedMarineLife += 1
					return
	else:
		for fish in selectedtank.fishList:
			if fish not in checkedfishlist:
				checkedfishlist.append(fish)
				if fish.harvestStatus == true:
					fish.get_node("Sprite2D").material.set_shader_parameter("onOff", 0.0);
					fish.get_node("Harvest").start()
					fish.harvestStatus = false
					if fish.Species == ThEnums.FishSpecies.Guppy:
						PlayerManager.xp += 1
						PlayerManager.money += 1
					elif fish.Species == ThEnums.FishSpecies.Clownfish:
						PlayerManager.xp += 3
						PlayerManager.money += 3
					harvestedMarineLife += 1
				return
				
	
	
	
	#print("WORK CALLED")
	#for tank in TankManager.tankList:
		#if tank.fishList.size() == 0 && tank.plantList.size() == 0:
			#pass
		#else:
			#if tank.fishList.size() >= 1:
				#for fish in tank.fishList:
					#print(fish.fishname)
			#if tank.plantList.size() >= 1:
				#for plant in tank.plantList:
					#print("found a plant")
					
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
	if PlayerManager.money >= level * 100:
		level += 1
		timetoharvest = 11 - level
		makeWorkTimer()

## Fish Friends
## Last Updated: 4/1/25 by Ayden Dueker
## Plant Parent Script
## - This node is a child of the MarineLife node, 
##   and the parent node for specific plant nodes.

extends MarineLife
class_name Plant
var counter
var timePassed
var collisionShape

@export var Species: ThEnums.PlantSpecies

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxSpeed = 0
	wanderTime = 0
	wanderRadius = 0
	wanderWeight = 0
	boundsWeight = 0
	super._ready()
	$Harvest.wait_time = 60 - get_parent().fishList.size() * 5
	if $Harvest.wait_time < 10:
		$Harvest.wait_time = 10
	$Harvest.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	#timePassed += delta
	#if timePassed >= 1.0:
		#counter += 10
		#timePassed = 0
		#print(counter)

#When the plant is ready to be harvested
func plant_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			if self.harvestStatus == true:
				$Sprite2D.material.set_shader_parameter("onOff", 0.0);
				$Harvest.wait_time = 60 - get_parent().fishList.size() * 5
				if $Harvest.wait_time < 10:
					$Harvest.wait_time = 10
				$Harvest.start()
				self.harvestStatus = false
				if self.Species == ThEnums.PlantSpecies.Guppygrass:
					PlayerManager.xp += 1
					var plantscene = load("res://scenes/Plant.tscn").instantiate()
					plantscene.Species = ThEnums.PlantSpecies.Guppygrass
					PlayerManager.marineLifeInventory.append(plantscene)
					UiManager.ReloadAllUI()
				elif self.Species == ThEnums.PlantSpecies.Anemone:
					PlayerManager.xp += 3
					var plantscene = load("res://scenes/Anemone.tscn").instantiate()
					plantscene.Species = ThEnums.PlantSpecies.Anemone
					PlayerManager.marineLifeInventory.append(plantscene)
					UiManager.ReloadAllUI()

#When the harvest timer goes off
func _on_harvest_timeout() -> void:
	$Harvest.stop()
	self.harvestStatus = true
	$Sprite2D.material.set_shader_parameter("onOff", 1.0)
	
	
func _can_drop_data(_pos,data):
	if data is Fish && self.get_parent().fishList.size() >= self.get_parent().fishCapacity:
		Notifier.push_notification("TANK IS FULL OF FISH")
	if data is Plant && self.get_parent().plantList.size() >= self.get_parent().plantCapacity:
		Notifier.push_notification("TANK IS FULL OF PLANTS")
	
	
	if data.waterType != ThEnums.WaterType.Fresh && self.tank_type == ThEnums.WaterType.Fresh:
		Notifier.push_notification("CANNOT PLACE MARINE LIFE OF DIFFERENT WATER TYPE")
		return false
	
	elif data.waterType != ThEnums.WaterType.Salt && self.tank_type == ThEnums.WaterType.Salt:
		Notifier.push_notification("CANNOT PLACE MARINE LIFE OF DIFFERENT WATER TYPE")
		return false
	
	if data is Node:
		if data is Fish && self.get_parent().fishList.size() < self.get_parent().fishCapacity:
			return true
		elif data is Plant && self.get_parent().plantList.size() < self.get_parent().plantCapacity:
			return true
	else:
		
		return false

func _drop_data(_pos, data):
	if data is Node:
		
		if data is Fish && !(self.get_parent().ishList.size() >= self.get_parent().fishCapacity):
			self.get_parent().AddFish(data)
		elif data is Plant && !(self.get_parent().plantList.size() >= self.get_parent().plantCapacity):
			self.get_parent().AddPlant(data)
		
		PlayerManager.marineLifeInventory.erase(data)
			
		
		var Main = get_tree().current_scene
		var dragDrop = Main.get_node("DragDropMenu")
		if dragDrop and dragDrop.has_method("populate_hbox_container"):
			dragDrop.populate_hbox_container()
		
		data.queue_free()	

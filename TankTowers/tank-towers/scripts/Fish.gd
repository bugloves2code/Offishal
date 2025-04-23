## Fish Friends
## Last Updated: 4/1/25 by Justin Ferreira
## Fish Script
## - This node is a child of the MarineLife node, 
##   and the parent node for specific fish nodes.

extends MarineLife
class_name Fish

signal fishClicked

var scrollContainer
var last_scroll = 0
var parent_global_pos
var collisionShape

@export var Species: ThEnums.FishSpecies
## Fish Properties
var fishname : String

## Fish Ui Scene
@export var FishUI : CanvasLayer

func _CalcSteeringForces() -> void:
	totalForce += Wander(wanderTime, wanderRadius) * wanderWeight
	totalForce += StayInBoundsForce() * boundsWeight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	super._ready()
	# 
	# Prevent fish from colliding with each other, stopping them from
	# flying off the top of the screen when they spawn at the same position
	# Is this the best place for this line? I have no idea!
	FishUI = UiManager.FishUI
	collision_layer = 0;
	$Harvest.start()

func adjustFishBounds() -> void:
	collisionShape = get_parent().get_node("Area2D/CollisionShape2D") as CollisionShape2D
	var rectShape = collisionShape.shape as RectangleShape2D
	var halfSize = rectShape.size * 0.5
	# There is a position already on Node2D sop this causes a warning - Justin
	var position = collisionShape.global_position

	var offset = collisionShape.position
	var center = position + offset
	## you might just bebale to inherit these from PhysicObject
	var xMin = center.x - halfSize.x
	var xMax = center.x + halfSize.x
	var yMin = center.y - halfSize.y
	var yMax = center.y + halfSize.y
	
	xMin = xMin
	xMax = xMax
	yMin = yMin
	yMax = yMax
	centerToSeek = center

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	adjustFishBounds()
	super._process(delta)

## fish_clicked
## Allows user to access Fish UI when
## Fish is clicked and not harvestable
## when Fish is harvestable the harvest function
## should be called
func fish_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			if self.harvestStatus == true:
				emit_signal("fishClicked")
				$Sprite2D.material.set_shader_parameter("onOff", 0.0);
				$Harvest.start()
				self.harvestStatus = false
				if self.Species == ThEnums.FishSpecies.Guppy:
					if PlayerManager.unlockNursery == true:
						if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
							self.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
							PlayerManager.xp += 1
							if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
								self.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
								PlayerManager.xp += 1
								if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
									self.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
									PlayerManager.xp += 1
									if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
										self.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
										PlayerManager.xp += 1
									else:
										PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
										UiManager.ReloadAllUI()
										PlayerManager.xp += 1
								else:
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
									UiManager.ReloadAllUI()
									PlayerManager.xp += 2
							else:
								PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
								PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
								PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
								UiManager.ReloadAllUI()
								PlayerManager.xp += 3
								
						else:
							PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
							PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
							PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
							PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
							UiManager.ReloadAllUI()
							PlayerManager.xp += 4
						return
					if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
						self.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
						PlayerManager.xp += 2
						if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
							self.get_parent().AddFish(load("res://scenes/Fish.tscn").instantiate())
						else:
							Notifier.push_notification("TANK IS FULL OF FISh, GUPPY ADDED TO INVENTORY")
							PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
							UiManager.ReloadAllUI()
							PlayerManager.xp += 1
					else:
						Notifier.push_notification("TANK IS FULL OF FISH, GUPPY ADDED TO INVENTORY")
						PlayerManager.marineLifeInventory.append(load("res://scenes/Fish.tscn").instantiate())
						UiManager.ReloadAllUI()
						PlayerManager.xp += 1
						
				elif self.Species == ThEnums.FishSpecies.Pike:
					if PlayerManager.unlockNursery == true:
						if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
							self.get_parent().AddFish(load("res://scenes/Pike.tscn").instantiate())
							PlayerManager.xp += 50
							if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
								self.get_parent().AddFish(load("res://scenes/Pike.tscn").instantiate())
								PlayerManager.xp += 50
								if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
									self.get_parent().AddFish(load("res://scenes/Pike.tscn").instantiate())
									PlayerManager.xp += 50
									if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
										self.get_parent().AddFish(load("res://scenes/Pike.tscn").instantiate())
										PlayerManager.xp += 50
									else:
										PlayerManager.marineLifeInventory.append(load("res://scenes/Pike.tscn").instantiate())
										UiManager.ReloadAllUI()
										PlayerManager.xp += 50
								else:
									PlayerManager.marineLifeInventory.append(load("res://scenes/Pike.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/Pike.tscn").instantiate())
									UiManager.ReloadAllUI()
									PlayerManager.xp += 100
							else:
								PlayerManager.marineLifeInventory.append(load("res://scenes/Pike.tscn").instantiate())
								PlayerManager.marineLifeInventory.append(load("res://scenes/Pike.tscn").instantiate())
								PlayerManager.marineLifeInventory.append(load("res://scenes/Pike.tscn").instantiate())
								UiManager.ReloadAllUI()
								PlayerManager.xp += 150
								
						else:
							PlayerManager.marineLifeInventory.append(load("res://scenes/Pike.tscn").instantiate())
							PlayerManager.marineLifeInventory.append(load("res://scenes/Pike.tscn").instantiate())
							PlayerManager.marineLifeInventory.append(load("res://scenes/Pike.tscn").instantiate())
							PlayerManager.marineLifeInventory.append(load("res://scenes/Pike.tscn").instantiate())
							UiManager.ReloadAllUI()
							PlayerManager.xp += 200
						return
					if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
						self.get_parent().AddFish(load("res://scenes/Pike.tscn").instantiate())
						PlayerManager.xp += 100
						if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
							self.get_parent().AddFish(load("res://scenes/Pike.tscn").instantiate())
						else:
							Notifier.push_notification("TANK IS FULL OF FISh, GUPPY ADDED TO INVENTORY")
							PlayerManager.marineLifeInventory.append(load("res://scenes/Pike.tscn").instantiate())
							UiManager.ReloadAllUI()
							PlayerManager.xp += 50
					else:
						Notifier.push_notification("TANK IS FULL OF FISH, GUPPY ADDED TO INVENTORY")
						PlayerManager.marineLifeInventory.append(load("res://scenes/Pike.tscn").instantiate())
						UiManager.ReloadAllUI()
						PlayerManager.xp += 50
						
				elif self.Species == ThEnums.FishSpecies.Clownfish:
					if PlayerManager.unlockNursery == true:
						if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
							self.get_parent().AddFish(load("res://scenes/ClownFish.tscn").instantiate())
							PlayerManager.xp += 5
							if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
								self.get_parent().AddFish(load("res://scenes/ClownFish.tscn").instantiate())
								PlayerManager.xp += 5
								if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
									self.get_parent().AddFish(load("res://scenes/ClownFish.tscn").instantiate())
									PlayerManager.xp += 5
									if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
										self.get_parent().AddFish(load("res://scenes/ClownFish.tscn").instantiate())
										PlayerManager.xp += 5
									else:
										PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
										UiManager.ReloadAllUI()
										PlayerManager.xp += 5
								else:
									PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
									UiManager.ReloadAllUI()
									PlayerManager.xp += 10
							else:
								PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
								PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
								PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
								UiManager.ReloadAllUI()
								PlayerManager.xp += 15
								
						else:
							PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
							PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
							PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
							PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
							UiManager.ReloadAllUI()
							PlayerManager.xp += 20
						return
					if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
						self.get_parent().AddFish(load("res://scenes/ClownFish.tscn").instantiate())
						PlayerManager.xp += 5
						if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
							self.get_parent().AddFish(load("res://scenes/ClownFish.tscn").instantiate())
						else:
							Notifier.push_notification("TANK IS FULL OF FISH, CLOWNFISH ADDED TO INVENTORY")
							PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
							UiManager.ReloadAllUI()
							PlayerManager.xp += 5
					else:
						Notifier.push_notification("TANK IS FULL OF FISH, CLOWNFISH ADDED TO INVENTORY")
						PlayerManager.marineLifeInventory.append(load("res://scenes/ClownFish.tscn").instantiate())
						UiManager.ReloadAllUI()
						PlayerManager.xp += 5
						
				elif self.Species == ThEnums.FishSpecies.BlueTang:
					if PlayerManager.unlockNursery == true:
						if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
							self.get_parent().AddFish(load("res://scenes/BlueTang.tscn").instantiate())
							PlayerManager.xp += 100
							if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
								self.get_parent().AddFish(load("res://scenes/BlueTang.tscn").instantiate())
								PlayerManager.xp += 100
								if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
									self.get_parent().AddFish(load("res://scenes/BlueTang.tscn").instantiate())
									PlayerManager.xp += 100
									if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
										self.get_parent().AddFish(load("res://scenes/BlueTang.tscn").instantiate())
										PlayerManager.xp += 100
									else:
										PlayerManager.marineLifeInventory.append(load("res://scenes/BlueTang.tscn").instantiate())
										UiManager.ReloadAllUI()
										PlayerManager.xp += 100
								else:
									PlayerManager.marineLifeInventory.append(load("res://scenes/BlueTang.tscn").instantiate())
									PlayerManager.marineLifeInventory.append(load("res://scenes/BlueTang.tscn").instantiate())
									UiManager.ReloadAllUI()
									PlayerManager.xp += 200
							else:
								PlayerManager.marineLifeInventory.append(load("res://scenes/BlueTang.tscn").instantiate())
								PlayerManager.marineLifeInventory.append(load("res://scenes/BlueTang.tscn").instantiate())
								PlayerManager.marineLifeInventory.append(load("res://scenes/BlueTang.tscn").instantiate())
								UiManager.ReloadAllUI()
								PlayerManager.xp += 300
								
						else:
							PlayerManager.marineLifeInventory.append(load("res://scenes/BlueTang.tscn").instantiate())
							PlayerManager.marineLifeInventory.append(load("res://scenes/BlueTang.tscn").instantiate())
							PlayerManager.marineLifeInventory.append(load("res://scenes/BlueTang.tscn").instantiate())
							PlayerManager.marineLifeInventory.append(load("res://scenes/BlueTang.tscn").instantiate())
							UiManager.ReloadAllUI()
							PlayerManager.xp += 400
						return
					if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
						self.get_parent().AddFish(load("res://scenes/BlueTang.tscn").instantiate())
						PlayerManager.xp += 100
						if self.get_parent().fishList.size() < self.get_parent().fishCapacity:
							self.get_parent().AddFish(load("res://scenes/BlueTang.tscn").instantiate())
						else:
							Notifier.push_notification("TANK IS FULL OF FISH, BLUE TANG ADDED TO INVENTORY")
							PlayerManager.marineLifeInventory.append(load("res://scenes/BlueTang.tscn").instantiate())
							UiManager.ReloadAllUI()
							PlayerManager.xp += 100
					else:
						Notifier.push_notification("TANK IS FULL OF FISH, BLUE TANG ADDED TO INVENTORY")
						PlayerManager.marineLifeInventory.append(load("res://scenes/BlueTang.tscn").instantiate())
						UiManager.ReloadAllUI()
						PlayerManager.xp += 100
			else:
				FishUI.loadFish(self)
				FishUI.loadFishUI()
				UiManager.CloseInventory()
				UiManager.CloseShop()
				UiManager.CloseTankCreationUI()
				

#When the harvest timer goes off
func _on_harvest_timeout() -> void:
	$Harvest.stop()
	self.harvestStatus = true
	$Sprite2D.material.set_shader_parameter("onOff", 1.0)


func _on_timer_timeout() -> void:
	pass # Replace with function body.
	
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

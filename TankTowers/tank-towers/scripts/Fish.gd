## Fish Friends
## Last Updated: 4/1/25 by Justin Ferreira
## Fish Script
## - This node is a child of the MarineLife node, 
##   and the parent node for specific fish nodes.

extends MarineLife
class_name Fish


var scrollContainer
var last_scroll = 0
var parent_global_pos
var collisionShape

var fishType: ThEnums.FishSpecies
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
	collisionShape = get_parent().get_node("Area2D/CollisionShape2D") as CollisionShape2D

func adjustFishBounds() -> void:
	var rectShape = collisionShape.shape as RectangleShape2D
	var halfSize = rectShape.size * 0.5
	# There is a position already on Node2D sop this causes a warning - Justin
	var position = collisionShape.global_position

	var offset = collisionShape.position
	var center = position + offset
	## print("position", center)
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
			if self.harvestStatus == false:
				FishUI.loadFish(self)
				FishUI.loadFishUI()
				PlayerManager.xp += 1
				PlayerManager.money += 1
			else:
				print("Harvest")

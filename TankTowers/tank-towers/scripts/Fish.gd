## Fish Friends
## Last Updated: 2/5/25 by William Duprey
## Fish Script
## - This node is a child of the MarineLife node, 
##   and the parent node for specific fish nodes.

extends MarineLife
class_name Fish

var scrollContainer
var last_scroll = 0
var parent_global_pos
var collisionShape

var fishname : String

@export var FishUI : PackedScene
var fish_ui_instance : CanvasLayer

func _CalcSteeringForces() -> void:
	totalForce += Wander(wanderTime, wanderRadius) * wanderWeight
	totalForce += StayInBoundsForce() * boundsWeight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Prevent fish from colliding with each other, stopping them from
	# flying off the top of the screen when they spawn at the same position
	# Is this the best place for this line? I have no idea!
	super._ready()
	fish_ui_instance = FishUI.instantiate()
	fish_ui_instance.loadFish(self)
	add_child(fish_ui_instance)
	fish_ui_instance.visible = false
	collision_layer = 0;
	collisionShape = get_parent().get_node("Area2D/CollisionShape2D") as CollisionShape2D

func adjustFishBounds() -> void:
	var rectShape = collisionShape.shape as RectangleShape2D
	var halfSize = rectShape.size * 0.5
	var position = collisionShape.global_position

	var offset = collisionShape.position
	var center = position + offset
	## print("position", center)
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


func fish_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			if self.harvestStatus == false:
				fish_ui_instance.loadFishUI()
			else:
				print("Harvest")

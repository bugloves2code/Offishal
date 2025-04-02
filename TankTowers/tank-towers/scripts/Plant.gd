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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxSpeed = 0
	wanderTime = 0
	wanderRadius = 0
	wanderWeight = 0
	boundsWeight = 0
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	#timePassed += delta
	#if timePassed >= 1.0:
		#counter += 10
		#timePassed = 0
		#print(counter)


func plant_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			if self.harvestStatus == false:
				PlayerManager.xp += 1
				PlayerManager.money += 1
			else:
				print("Harvest")

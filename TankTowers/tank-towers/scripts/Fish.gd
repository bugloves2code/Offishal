## Fish Friends
## Last Updated: 2/5/25 by William Duprey
## Fish Script
## - This node is a child of the MarineLife node, 
##   and the parent node for specific fish nodes.

extends MarineLife
class_name Fish


func _CalcSteeringForces() -> void:
	totalForce += Wander(wanderTime, wanderRadius) * wanderWeight
	totalForce += StayInBoundsForce() * boundsWeight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Prevent fish from colliding with each other, stopping them from
	# flying off the top of the screen when they spawn at the same position
	# Is this the best place for this line? I have no idea!
	collision_layer = 0;
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	## print("xMin:", xMin, "xMax:", xMax, "yMin:", yMin, "yMax:", yMax, "center:", centerToSeek)
	#print(centerToSeek)
	super._process(delta)

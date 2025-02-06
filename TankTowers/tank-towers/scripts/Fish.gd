## Fish Friends
## Last Updated: 2/4/25 by William Duprey
## Fish Script
## - This node is a child of the MarineLife node, 
##   and the parent node for specific fish nodes.

extends MarineLife

@export var wanderTime : float
@export var wanderRadius : float
@export var wanderWeight : float

func _CalcSteeringForces() -> void:
	totalForce += Wander(wanderTime, wanderRadius) * wanderWeight
	#totalForce += StayInBoundsForce()

#func StayInBoundsForce() -> Vector2:
	#if (global_position.x < 5||
			#global_position.x > 5 ||
			#global_position.y < 5||
			#global_position.y > 5)
		#{
			#Vector2 cameraPosition = Vector2.ZERO;
			#cameraPosition.z = transform.position.z;
			#return Seek(cameraPosition);
		#}
		#return Vector3.zero; 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)

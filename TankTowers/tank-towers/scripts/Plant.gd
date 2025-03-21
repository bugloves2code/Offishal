## Fish Friends
## Last Updated: 2/4/25 by William Duprey
## Plant Parent Script
## - This node is a child of the MarineLife node, 
##   and the parent node for specific plant nodes.

extends MarineLife
var counter
var timePassed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	timePassed += delta
	if timePassed >= 1.0:
		counter += 10
		timePassed = 0
		#print(counter)

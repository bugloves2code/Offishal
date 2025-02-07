extends Node


@export var fishScene: PackedScene


# Last Edited by Ayden Dueker
# this promotes a lot of coupling/ high dependency between this manager and Tank with
# it taking in a reference to a tank to spawn a fish, we can discuss if this ideal or not 
# in the future
func SpawnFish(tank: Tank) -> Fish:
	var collisionShape = tank.get_node("CollisionShape2D") as CollisionShape2D
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
	
	var fish : Fish = fishScene.instantiate()
	tank.add_child(fish)
	fish.xMin = xMin
	fish.xMax = xMax
	fish.yMin = yMin
	fish.yMax = yMax
	fish.centerToSeek = center
	return fish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fishScene = load("res://scenes/Fish.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

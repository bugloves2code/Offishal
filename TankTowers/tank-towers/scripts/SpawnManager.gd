## Fish Friends
## Last upadated 4/1/25 by Ayden Dueker
## SpawnManager Script

extends Node


@export var fishScene: PackedScene
@export var plantScene : PackedScene

var plantPositions: Array = [
Vector2(110, 180), 
Vector2(145, 180), 
Vector2(180, 180), 
Vector2(215, 180), 
Vector2(250, 180), 
Vector2(285, 180), 
Vector2(320, 180), 
Vector2(355, 180), 
Vector2(390, 180), 
Vector2(425, 180)]

func SpawnPlant(tank: Tank) -> Plant:
	var plant : Plant = plantScene.instantiate()
	tank.add_child(plant)
	plant.position = plantPositions[tank.plantList.size() - 1]
	return plant


# Last Edited by Ayden Dueker
# this promotes a lot of coupling/ high dependency between this manager and Tank with
# it taking in a reference to a tank to spawn a fish, we can discuss if this ideal or not 
# in the future
func SpawnFish(tank: Tank) -> Fish:
	var collisionShape = tank.get_node("Area2D/CollisionShape2D") as CollisionShape2D
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
	#tank.add_child(fish)
	fish.xMin = xMin
	fish.xMax = xMax
	fish.yMin = yMin
	fish.yMax = yMax
	fish.centerToSeek = center
	return fish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fishScene = load("res://scenes/Fish.tscn")
	plantScene = load("res://scenes/Plant.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

## Fish Friends
## Last Updated: 2/4/25 by William Duprey
## MarineLife Parent Node
## - This node is the parent class for fish and plant nodes,
##   and contains properties and methods that each need

extends Node2D

## Some notes:
## - Must use @export if you want a property to be 
##   visible / editable in the inspector
## - Exported variables must have a type, but do not
##   have to have a default value
## - Any comments that are documentation of a class, 
##   property, method, etc. should use double hashtags
## - Placing a "##" comment above a property will make it
##   so hovering over it in the inspector shows that comment

## The age of the marine life. Used to update its
## appearance as it ages, and track whether it
## is ready to be harvested.
@export var age : float = 0.0;

## The type of water in which the marine life can live.
@export var waterType : ThEnums.WaterType;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

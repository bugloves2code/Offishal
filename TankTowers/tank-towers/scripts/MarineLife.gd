## Fish Friends
## Last Updated: 4/1/25 by Justin Ferreira
## MarineLife Parent Script
## - This node is the parent class for fish and plant nodes,
##   and contains properties and methods that each need

extends PhysicsObject
class_name MarineLife

## Some notes:
## - Must use @export if you want a property to be 
##   visible / editable in the inspector
## - Exported variables must have a type, but do not
##   have to have a default value
## - Any comments that are documentation of a class, 
##   property, method, etc. should use double hashtags
## - Placing a "##" comment above a property will make it
##   so hovering over it in the inspector shows that comment
## - Sometimes the inspector can be slow to update, but I've
##   found that commenting / uncommenting the property will
##   usually get the inspector properly showing what it should

## The age of the marine life. Used to update its
## appearance as it ages, and track whether it
## is ready to be harvested.
@export var age : float = 0.0;

## The age at which the marine life is ready to be harvested.
## - Note: It might be better to use a Timer node for this?
##   I'm not sure how those work.
@export var harvestAge: float;

## The type of water in which the marine life can live.
## - Defaults to fresh water to avoid warnings.
@export var waterType : ThEnums.WaterType = ThEnums.WaterType.Fresh;

## Other types of marine life that this marine life can
## comfortably live with. 
## - Note: I have no idea if polymorphism is even possible in GDScript.
##   I think typed arrays are possible? I did do some documentation-reading,
##   and typed arrays are possible, and the syntax is below.
@export var compatible : Array[MarineLife];

## sell_price
## this is how much money the player will earn
## from selling this MarineLife
@export var sell_price: int = 1

## harvestStatus
## this is a bool that indicates when
## a MarineLife is ready to be harvested
var harvestStatus: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	

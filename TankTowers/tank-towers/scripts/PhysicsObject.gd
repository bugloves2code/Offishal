extends CharacterBody2D
class_name PhysicsObject

# last edited : Ayden Dueker 2/4
# this class contains methods that will allow anything that extends it to calculate their movement
# specifically right now, a Seek, or Wander behavior which can later be explanded to flocking or fleeing

# right now I am determining if we should add more abstraction behavior by having the fish for example directly
# inherit from this. I also don't want to directly put these methods in the fish class but at the same time, Marine Life
# would have to extend this but plants dont move LOL. But its probably fine

@export var maxSpeed : int

# Provide default values so that fish 
# are not braindead upon being created
@export var wanderTime : float = 30
@export var wanderRadius : float = 60
@export var wanderWeight : float = 50
@export var boundsWeight : float = 10

# these variables represent the bounds of any physics object
var xMax : float
var xMin : float
var yMax : float
var yMin : float

# if there is somewhere the physicsObject needs to seek to
# other then the center of the viewpoint, this can be set
var centerToSeek : Vector2

var wanderAngle
var perlinOffset

var sprite
var direction

var velocityFactor: Vector2 = Vector2.ZERO

var totalForce
var acceleration: Vector2 = Vector2.ZERO

var noise: FastNoiseLite

var rng = RandomNumberGenerator.new()

# this method will be overrided
func _CalcSteeringForces() -> void:
	pass

func ApplyForce(force: Vector2) -> void:
	acceleration += force / 2 #10 is a placeholder for mass, idk if we want to mess with this at all
	pass

func CalcFuturePosition(time: float) -> Vector2:
	return global_position + (velocity * time)

func Seek(targetPos: Vector2) -> Vector2:
	var desiredVel = targetPos - global_position
	desiredVel = desiredVel.normalized() * maxSpeed
	return desiredVel - velocity;

func Wander(time: float, radius: float) -> Vector2:
	var futurePos = CalcFuturePosition(time)
	var noiseCalc = noise.get_noise_2d(global_position.x * 0.1 + perlinOffset, global_position.y * 0.1 + perlinOffset);
	#var noiseCalc = (noise.get_noise_2d(global_position.x * 0.1 + perlinOffset, global_position.y * 0.1 + perlinOffset) + 1) / 2.0
	#wanderAngle += (0.5 - noiseCalc * (PI * get_process_delta_time())) 
	wanderAngle += (noiseCalc - 0.5) * PI * get_process_delta_time()
	
	var targetPos = Vector2(cos(wanderAngle) * radius, sin(wanderAngle) * radius)
	return Seek(futurePos + targetPos)

func StayInBoundsForce() -> Vector2:
	if (global_position.x < xMin||
		global_position.x > xMax ||
		global_position.y < yMin||
		global_position.y > yMax):
			#print("hi")
			return Seek(centerToSeek)
	else:
		return Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	perlinOffset = rng.randf_range(0, 1000)
	wanderAngle = rng.randf_range(0, PI * 2)
	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.1
	sprite = get_node("Sprite2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	totalForce = Vector2.ZERO;
	_CalcSteeringForces()
	ApplyForce(totalForce)
	#velocityFactor += acceleration * delta;
	velocity += acceleration * delta;
	velocity = velocity.limit_length(maxSpeed)
	
	# Assuming `velocity` is a Vector2 and `sRenderer` is a Sprite node
	if (velocity.length() > 0.000001):
		direction = velocity.normalized()

# Flip the sprite based on the direction
	if direction.x < 0:
		sprite.flip_v = true  # Flip the sprite horizontally
	else:
		sprite.flip_v = false

# Rotate the object to face the direction of movement
	rotation = direction.angle()

	acceleration = Vector2.ZERO;
	move_and_slide()

extends CharacterBody2D
class_name PhysicsObject

# last edited : Ayden Dueker 2/4
# this class contains methods that will allow anything that extends it to calculate their movement
# specifically right now, a Seek, or Wander behavior which can later be explanded to flocking or fleeing

# right now I am determining if we should add more abstraction behavior by having the fish for example directly
# inherit from this. I also don't want to directly put these methods in the fish class but at the same time, Marine Life
# would have to extend this but plants dont move LOL. But its probably fine

@export var maxSpeed : int

# these variables represent the bounds of any physics object
var xMax : float
var xMin : float
var yMax : float
var yMin : float

var wanderAngle
var perlinOffset

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
	return Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	perlinOffset = rng.randf_range(0, 1000)
	wanderAngle = rng.randf_range(0, PI * 2)
	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.1
	maxSpeed = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	totalForce = Vector2.ZERO;
	_CalcSteeringForces()
	ApplyForce(totalForce)
	#velocityFactor += acceleration * delta;
	velocity += acceleration * delta;
	velocity = velocity.limit_length(maxSpeed)
	#print("Wander force:", Wander(wanderTime, wanderRadius))

	#velocityFactor = Vector2(clamp(velocityFactor.x, 1, 5), clamp(velocityFactor.y, 1, 5)) # placeholder for min and max clamp velocity, can be made variables later
	#velocity = velocityFactor
	#print(velocity)
	acceleration = Vector2.ZERO;
	move_and_slide()

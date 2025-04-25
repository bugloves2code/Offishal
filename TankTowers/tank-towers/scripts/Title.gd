extends Node
signal gameStart
@onready var anim = $AnimationPlayer
@onready var waterAnim = $WaterAnimater
var connect: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("/root/Main/PlayerUI").visible = false
	##anim.play("titleAnim")
	anim.play("backgroundLoop")
	waterAnim.play("waterMove")
	##anim.play("waterMove")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if connect:
		#if (has_node("/root/Main/Title/AnimationPlayer")):
			#playAnim()
	pass


func _on_button_pressed() 	-> void:
	self.visible = false
	get_node("/root/Main/PlayerUI").visible = true
	emit_signal("gameStart")

extends Control

signal tutorial_continue

@onready var instruction_label = $Sprite2D/Sprite2D2/RichTextLabel
##@onready var tap_prompt = $TapPrompt
@onready var anim = $AnimationPlayer

var can_continue := false

func _ready():
	visible = false
	set_process_input(true)
	##tap_prompt.visible = false

func show_tutorial(text: String):
	instruction_label.text = text
	instruction_label.add_theme_font_size_override("font_size", 50)
	##tap_prompt.visible = true
	visible = true
	can_continue = false
	anim.play("slide_in")
	##await get_tree().create_timer(0.3).timeout
	can_continue = true

func hide_tutorial():
	can_continue = false
	anim.play("slide_out")
	##await anim.animation_finished


func _input(event):
	if can_continue and event is InputEventMouseButton and event.pressed:
		emit_signal("tutorial_continue")
		print("hi")

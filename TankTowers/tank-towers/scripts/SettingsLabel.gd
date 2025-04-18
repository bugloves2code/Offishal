## Fish Friends
## Last upadated 4/1/25 by Justin Ferreira
## Settings Label
## Controls label under a slider so it displays correct number

extends Label

@export var slider: HSlider

func _ready():
	slider.value_changed.connect(update_text)
	update_text(slider.value)

func update_text(value: float):
	var clamped_value := clampf(value, slider.min_value, slider.max_value)
	var percentage := int(round(clamped_value))
	text = "%d%%" % [int(percentage)]

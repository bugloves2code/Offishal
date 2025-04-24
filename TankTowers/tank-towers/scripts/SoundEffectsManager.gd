extends Node

## SFX

var tankCreation = load("res://audio/tankCreation.wav")

var fishAdd = load("res://audio/bloop.wav")

var plantAdd = load("res://audio/plantAdd.wav")

var levelUp = load("res://audio/levelUp.wav")

var upgradePurchase = load("res://audio/upgradePurchase.wav")

var unlockShop = load("res://audio/unlockShop.wav")

var buy = load("res://audio/buy.wav")

var unlockAll = load("res://audio/unlockAll.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func play_sound(sound_stream: AudioStream):
	var new_player = AudioStreamPlayer.new()
	new_player.stream = sound_stream
	add_child(new_player)
	new_player.play()
	# Automatically remove after playback
	await new_player.finished
	new_player.queue_free()

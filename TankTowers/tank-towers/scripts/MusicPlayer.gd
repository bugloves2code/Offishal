## Fish Friends
## Last Updated: 4/1/25 by Ayden Dueker
## Music Player Script

extends AudioStreamPlayer 

func _ready():
	var song = load("res://audio/fishSong.mp3")  # Replace with your actual file path
	stream = song
	playing = true
	bus = "Music"
	finished.connect(_on_music_finished)

func _on_music_finished():
	play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

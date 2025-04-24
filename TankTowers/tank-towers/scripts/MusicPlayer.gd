## Fish Friends
## Last Updated: 4/1/25 by Ayden Dueker
## Music Player Script

extends AudioStreamPlayer 
var song
var titleSong



func _ready():
	song = load("res://audio/fishSong.mp3")  # Replace with your actual file path
	titleSong = load("res://audio/underwater-ambience.mp3")
	
	#stream = song
	#playing = true
	#bus = "Music"
	#finished.connect(_on_music_finished)

func _on_music_finished():
	play()

func playTitleMusic():
	stream = titleSong
	playing = true
	bus = "Music"
	pass

func playGameMusic():
	stream = song
	playing = true
	bus = "Music"
	finished.connect(_on_music_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

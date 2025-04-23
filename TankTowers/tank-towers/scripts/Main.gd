extends Node
@export var tutorial_manager: NodePath
var connect: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.playTitleMusic()
	pass
	##get_node("/root/Main/Title").connect("gameStart", Callable(self, "gameStart"))

func gameStart():
	connect = false
	var tutorial = get_node(tutorial_manager)
	tutorial.start_tutorial()
	MusicPlayer.playGameMusic()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if connect:
		if has_node("/root/Main/Title"):
			if (!get_node("/root/Main/Title").is_connected("gameStart", Callable(self, "gameStart"))):
				get_node("/root/Main/Title").connect("gameStart", Callable(self, "gameStart"))
			else:
				pass
		else:
			pass

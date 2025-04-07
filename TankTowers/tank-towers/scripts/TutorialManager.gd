extends Node

var tutorialLabel : Label
##@onready var tutorialLabel : Label = $Tutorial/Label

var tutorialFinished : bool = false
var currentTank : Tank

var tutorialSteps = {
	"step1" :"Welcome to Tank Towers! Click 'Create Tank' to begin!",
	"step2" :"Great! Now you have a tank. Click on a tank to view your inventory.",
	"step3" :"Alright now add the fish the the tank!",
	"step4" :"Sweet, Congrats on your new fish! It will help grow your plants faster!"
}

var completedSteps = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tutorialLabel = Label.new()
	tutorialLabel.add_theme_font_size_override("font_size", 16)
	tutorialLabel.autowrap_mode = TextServer.AUTOWRAP_WORD
	tutorialLabel.custom_minimum_size = Vector2(300, 0)
	add_child(tutorialLabel)
	tutorialLabel.position = Vector2(100, 100)
	showStep("step1");
	

func showStep(stepName):
	if stepName in tutorialSteps and stepName not in completedSteps:
		completedSteps[stepName] = true
		tutorialLabel.set("text", tutorialSteps[stepName])
		TankManager.connect("tankAdded", Callable(self, "onCreateClicked"))
		TankManager.disconnect("tankAdded", Callable(self, "onCreateClicked"))
		
		

func onCreateClicked():
	showStep("step2")
	currentTank = TankManager.tankList[0]
	currentTank.connect("tankClicked", Callable(self, "onTankClicked"))
	currentTank.disconnect("tankClicked", Callable(self, "onTankClicked"))
	currentTank.connect("addFish", Callable(self, "onAddFish"))
	currentTank.disconnect("addFish", Callable(self, "onAddFish"))


func onTankClicked():
	showStep("step3")

func onAddFish():
	showStep("step4")
	tutorialFinished = true

func _on_label_gui_input(_event: InputEvent) -> void:
	if (tutorialFinished == true):
		tutorialLabel.hide()

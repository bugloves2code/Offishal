## Fish Friends
## Last upadated 2/20/25 by Justin Ferreira
## TankUI Script
## - This script describes the UI layer for tanks
## this script is used to handle UI events
## UI events will be things such as add and removing fish

extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
## OnHarvestTankPressed this is the function that allows for the player to harvest
## all things that are harvestable in the tank this will probably become mutiple
## functions in the future
func OnHarvestTankPressed(tank):
	## If the tank can be harvested call the harvest function
	if(tank.harvestStatus):
		tank.HarvestTank()

## _on_create_tank_button_pressed is the function that is attached to the 
## Creat Tank Button and processes if a tank can be made and then adds it to
## the scene
func _on_create_tank_button_pressed() -> void:
	## print(tankList.size())
	UiManager.CloseFishUI()
	UiManager.ShowTankCreationUI()
	UiManager.ReloadAllUI()

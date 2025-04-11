## Fish Friends
## Last Updated: 4/1/25 by Justin Ferreira
## PlayerManager Autoload Script
## - This script controls the player's stats and inventory.

extends Node

## The player's current currency.
## - For simplicity, this is an integer instead of a float.
##   Whole numbers are easier to work with than decimals,
##   and we won't need to worry about any imprecision.
## - I would have preferred this to be an unsigned integer
##   to not have to worry about negative currency, but
##   can you take a wild guess what GDScript doesn't have?
@export var money: int = 10;

## The player's maximum currency.
## - There should probably be a maximum just so there's
##   never a possibility of overflowing to 0 or anything.
## - Also, capping at a nice satisfying number instead
##   of 2.148 billion or whatever is cleaner.
const moneyMax: int = 9999;

## The player's experience points.
## - We'd talked about having experience / leveling up,
##   so this is just laying the foundation for that
##   system, if we ever want to actually figure it out.
## - Determine whether this should reset to 0 after each
##   level up, or stay as a running total of all XP?
@export var xp: int = 0;

## The player's level.
## - Could be a way of unlocking new fish / plants / tank upgrades
##   in the shop, or maybe unlocking a new floor to buy?
## - Also figure out a good way of storing the XP thresholds for
##   each level up. 
##   - GDScript does have dictionaries. 
##   - Or we could come up with some formula to calculate the 
##     new required XP for the next level so that we wouldn't 
##     be storing useless data for previous levels after the 
##     player passes them. This is probably the better option,
##     since then we wouldn't need to worry about maintaining
##     a monstrous dictionary any time we want to tweak the
##     level scaling.
@export var level: int = 1;

## The player's max level.
## - Probably want to have an upper limit for the player's level.
##   Maybe we could have a system where the player can keep gaining
##   experience and get a reward for leveling up, but their
##   actual level doesn't go any higher than the maximum.
const levelMax: int = 99;

## The player's inventory for fish and plants.
## - I don't think inventory management is the experience
##   we're aiming for, so I think it makes sense to split the
##   player's inventory into these two categories.
## - Also, doing it this way means we don't need a common
##   "MarineLifeOrTankUpgrade" parent class or anything.
##   Although, if we do want to change this, I guess we
##   could just make it an array of Nodes, since that's the
##   parent class for everything.
## - Not exported because encapsulation? Is that even a 
##   thing in GDScript? I don't know.
var marineLifeInventory: Array[MarineLife];

## The player's inventory for tank upgrades.
## - We don't have a TankUpgrade script yet, so for now
##   this is just a regular, untyped array.
var tankInventory: Array;

var currentTankPrice


## Testing variables
var fish_scene = preload("res://scenes/Fish.tscn")
var plant_scene = preload("res://scenes/Plant.tscn")

## is_dragging
## variable that tracks if player is dragging something
var is_dragging = false

## current_dragged_item
## saves infomation about MarineLife being dragged
var current_dragged_item: MarineLife = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(2):
		var fish_instance = fish_scene.instantiate()
		marineLifeInventory.append(fish_instance)
	for i in range(2):
		marineLifeInventory.append(plant_scene.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if xp / level == 5:
		Levelup()


## --- Marine Life Inventory Functions ---
## - Not entirely sure if these methods are necessary.
##   Would other scripts / the inspector be able to just
##   access the functions of the marineLifeInventory array?
## - I think these would be good just to have explicit
##   functions for any UI button signals.
## ---------------------------------------

func MarineLifeInventoryCount() -> int:
	return marineLifeInventory.size();

func AddMarineLife(marineLife: MarineLife) -> void:
	marineLifeInventory.push_back(marineLife);	

func RemoveMarineLife(index: int) -> MarineLife:
	# Can throw an exception -- good! Let it!
	return marineLifeInventory.pop_at(index);
	
## Levelup
## This function updates all the stats the player gets
## when they level up
func Levelup():
	level += 1
	if(PlayerManager.level == 5):
		UiManager.PlayerUI.ShopStock.append({"texture": preload("res://assets/clownfish.png"), "price": 1, "Species": ThEnums.FishSpecies.Clownfish})
		UiManager.PlayerUI.PlantShopStock.append({"texture": preload("res://assets/anemone.png"), "price": 1, "Species": ThEnums.PlantSpecies.Anemone})
		Notifier.push_notification("LEVEL UP! NEW FISH AND PLANT UNLOCKED")
	else:
		Notifier.push_notification("LEVEL UP!")
	UiManager.ReloadAllUI()
	
func UpdateTankPrice(higherprice: bool):
	if higherprice:
		currentTankPrice = TankManager.tankList.size() * 5 + 15
	else:
		currentTankPrice = TankManager.tankList.size() * 5 + 5
	
	

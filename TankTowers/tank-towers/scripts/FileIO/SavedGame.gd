## Fish Friends
## Last updated 4/24/25 by William Duprey
## Game Data Resource Script
## - This script extends the Godot Resource class,
##   which is a built-in way of saving / loading
##   Nodes by exporting variables.
## - If we want something to be saved in the game,
##   it will need a corresponding exported variable
##   in this script, and saving / loading that data
##   will need to be handled in the SaverLoader script.
## - Mostly followed this Godot tutorial:
##   https://www.youtube.com/watch?v=43BZsLZheA4

class_name SavedGame
extends Resource

## The player's money.
@export var money: int;

## The player's current level.
@export var level: int;

## The player's experience points.
## - In the current implementation, it doesn't look like
##   these are reset after each level up.
## - Level up also seems to occur constantly at every five levels.
##   In any case, this is an integer. Gotta save that partial progress.
@export var xp: int;

## An array of tank data to be saved.
## - Each tank stores its water type, 
##   and arrays of fish and plants
@export var tanks: Array[SavedTank];

## An array of marine life data for the player's inventory.
## - In hindsight, the player's inventory should really
##   have been a dictionary, so that we would not need
##   to store an inordinate amount of full MarineLife nodes.
@export var inventory: Array[SavedMarineLife];

## An array of worker data to be saved.
## - Each worker has a level, number harvested, etc.
@export var workers: Array[SavedWorker];


## Whether the tutorial has been completed
@export var tutorialComplete: bool;

## Whether the nursery has been unlocked
@export var unlockNursery: bool;

## Whether the tank capacity has been unlocked
@export var unlockTankUpgrade: bool;

## Whether the auto sell has been unlocked
@export var unlockAutoSell: bool;

## Whether the fertilizer has been unlocked
@export var unlockFertilizer: bool;

## Whether the sell all upgrade has been unlocked
@export var unlockSellAll: bool;

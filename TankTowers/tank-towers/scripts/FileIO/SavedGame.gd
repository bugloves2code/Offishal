## Fish Friends
## Last updated 3/23/25 by William Duprey
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

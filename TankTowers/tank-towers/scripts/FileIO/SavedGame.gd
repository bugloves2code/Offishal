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

## The base price of a tank, which increases
## as the player adds more tanks.
## - This needs to be saved because of some hacky
##   stuff I have to do to get the existing tank
##   creation function to work right.
@export var tankPrice: int;

## An array of tank data to be saved.
## - Each tank stores its water type, 
##   and arrays of fish and plants
@export var tanks: Array[SavedTank];

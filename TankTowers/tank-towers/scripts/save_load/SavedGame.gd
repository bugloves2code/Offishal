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
@export var money:int;

## The number of tanks.
@export var tankCount:int;

## Temporary, since all this stores is the number
## of fish in each tank, but not any of their properties
@export var fishCounts:Array;

## An array of arrays of fish objects
## - First index is for the tank
## - Second index is for the fish
@export var fishList:Array;

## An array of arrays of plant objects
## - First index is for the tank
## - Second index is for the plant
@export var plantList:Array;

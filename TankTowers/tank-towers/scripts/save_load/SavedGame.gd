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

## An array of SavedMarineLife resources,
## one for each fish in a tank.
## - Indices into this array correspond to the
##   the counts of fish in each tank.
## - I would have preferred this to be an array
##   of arrays of SavedMarineLife, but GDScript
##   doesn't allow for an array of arrays type.
## - Instead of making a SavedFish or SavedPlant
##   resource, they share the same exact data
##   that needs to be shared, I just use a common resource.
@export var fishList:Array[SavedMarineLife];

## An array of SavedMarineLife resources,
## one for each plant in a tank.
@export var plantList:Array[SavedMarineLife];

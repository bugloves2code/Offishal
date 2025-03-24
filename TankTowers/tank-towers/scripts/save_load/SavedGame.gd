## Fish Friends
## Last updated 3/7/25 by William Duprey
## Game Data Resource Script
## - This script extends the Godot Resource class,
##   which is a built-in way of saving / loading
##   Nodes by exporting variables.
## - Mostly followed this Godot tutorial:
##   https://www.youtube.com/watch?v=43BZsLZheA4

class_name SavedGame
extends Resource

## The player's money.
@export var money:int;

## The number of tanks.
@export var tankCount:int;

## Fish Friends
## Last updated 3/31/25 by William Duprey
## MarineLife Data Resource Script
## - In the absence of GDScript supporting structs, 
##   I am reduced to making another class for saving
##   fish data.
## - This script extends the Godot Resource class,
##   which is a built-in way of saving / loading
##   Nodes by exporting variables.
## - The SavedGame resource has an array of SavedFish
##   objects that it will index according to the count
##   of fish in each tank.
## - Everything about a fish that needs to be saved has
##   a corresponding exported variable in this resource.

class_name SavedMarineLife
extends Resource

## Name of the marine life 
## - Nickname given by the player, not the name of the species
@export var name: String;

## Whether the marine life is ready to be harvested
## - I would have preferred to store the timer's value,
##   but that doesn't seem to be an accessible field.
##   All we have is whether the timer has finished.
@export var harvestStatus: bool;

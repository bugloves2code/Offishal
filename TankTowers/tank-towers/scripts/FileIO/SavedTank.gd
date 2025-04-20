## Fish Friends
## Last updated 4/20/25 by William Duprey
## Tank Data Resource Script
## - This script extends the Godot Resource class,
##   which is a built-in way of saving / loading
##   Nodes by exporting variables.
## - The SavedTank class exports all of the data that
##   a tank needs to function (water type, fish / plants, etc.)

class_name SavedTank
extends Resource

## Name of the tank
## - Probably just a default name, I don't think
##   we have a way to change the name
@export var name: String;

## The water type of the tank, allowing only
## fish and plants of that type to be added
@export var waterType: ThEnums.WaterType;

## Array of fish in the tank
## - Uses the SavedMarineLife type for simplicity
@export var fish: Array[SavedMarineLife];

## Array of plants in the tank
## - Uses the SavedMarineLife type for simplicity
@export var plants: Array[SavedMarineLife];

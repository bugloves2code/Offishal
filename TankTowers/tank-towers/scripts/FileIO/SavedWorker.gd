## Fish Friends
## Last updated 4/24/25 by William Duprey
## Worker Data Resource Script
## - This script extends the Godot Resource class,
##   which is a built-in way of saving / loading
##   Nodes by exporting variables.
## - The SavedWorker Resource stores everything that a
##   Worker needs to be saved and then loaded.

extends Resource
class_name SavedWorker

## The current level of the Worker, which 
## determines how efficiently they work.
@export var level: int;

## The number of marine life that the Worker
## has harvested, just used to track its stats.
@export var marineLifeHarvested: int;

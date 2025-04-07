## Fish Friends
## Last upadated 4/1/25 by Justin Ferreira
## TankManager Script
## - this script holds all things that will need to be
## universally accessed about tanks 
extends Node

# signal that comes on when a tank is added
signal tankAdded

## tank_scene 
## tank_scene holds then tank so we can instaniate it
## and edit it in the future
var tank_scene =  load("res://scenes/Tank.tscn")

## tankList
## this is the List which contains all tanks 
var tankList: Array = []

## tankCapacity
## amount of tanks player has unlocked
var tankCapacity = 20

func _process(delta: float) -> void:
	if (tankList.size() == 1):
		emit_signal("tankAdded")

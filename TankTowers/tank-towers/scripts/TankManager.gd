extends Node

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
var tankCapacity = 4

func _process(delta: float) -> void:
	if (tankList.size() == 1):
		emit_signal("tankAdded")

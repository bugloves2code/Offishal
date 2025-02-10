extends Node

## ui_panel 
## this is the panel hookup to the main Ui which
## shows tank data and allows editing to tank
@export var ui_panel: CanvasLayer

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


	

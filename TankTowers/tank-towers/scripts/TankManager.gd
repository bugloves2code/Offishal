## Fish Friends
## Last upadated 2/20/25 by Justin Ferreira
## TankManager Script
## - this script holds all things that will need to be
## universally accessed about tanks 
extends Node

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

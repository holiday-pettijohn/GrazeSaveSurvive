##CONTAINS GLOBAL CONSTANTS##
extends Node

#Size of the map
const MAP_WIDTH = 1600
const MAP_HEIGHT = 800
const MAP_SIZE = Vector2(MAP_WIDTH, MAP_HEIGHT)

#Size of the map
const GAME_WIDTH = 800
const GAME_HEIGHT = 800
const GAME_SIZE = Vector2(GAME_WIDTH, GAME_HEIGHT)

#Position of grid in Upgrades Menu
const GRID_X = 350
const GRID_Y = 50
const GRID_SIZE = 160

# Database constants
const DB_PATH = "res://database.sqlite3"

func _ready():
	pass

var GRAB_LOCK = false

func get_grab_lock():
	if GRAB_LOCK:
		return false
	GRAB_LOCK = true
	return GRAB_LOCK

func release_grab_lock():
	GRAB_LOCK = false

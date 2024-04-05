extends Node2D


var db : SQLite

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	db = SQLite.new()
	db.path = "res://database.sqlite3"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func save_items(player_id : int, picked_up_items : Array):
	db.open_db()
	for item_id in picked_up_items:
		db.insert_row("player_item_inventory", {"player_id": player_id, "item_id" : item_id})
	db.close_db()

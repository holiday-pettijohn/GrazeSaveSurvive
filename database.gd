extends Node

var db : SQLite = SQLite.new()
static var player_id : int = 0
var new_items : Array
var inventory : Array # contains [{"item_id" : ID#}]

func _ready():
	db.path = Globals.DB_PATH
	refresh()

func refresh():
	# Refresh and cache player inventory
	db.open_db()
	for item_id in new_items:
		db.insert_row("player_item_inventory", {"player_id": player_id, "item_id" : item_id})
	new_items.clear()
	inventory = db.select_rows("player_item_inventory", "player_id = " + var_to_str(player_id), ["item_id"])
	db.close_db()

func get_item_data(item_ids : Array):
	db.open_db()
	var items : Array
	var query_string = "SELECT hex(data) FROM item WHERE item_id = ?;"
	for item_id in item_ids:
		db.query_with_bindings(query_string, [item_id])
		items.push_back(db.query_result[0]["hex(data)"].hex_decode())
	db.close_db()
	return items

func add_items(item_ids : Array):
	for item_id in item_ids:
		new_items.push_back(item_id)
		

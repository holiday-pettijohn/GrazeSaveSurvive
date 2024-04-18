extends Node

var db : SQLite = SQLite.new()
static var player_id : int = 0
var new_items : Array
var new_grid : Array
var dropped_grid : Array
var inventory : Array # contains [ID#]
var grid : Array # contains [{x, y}*32]

func _ready():
	db.path = Globals.DB_PATH
	db.verbosity_level = 0
	refresh()

func refresh():
	# Refresh and cache player inventory and item grid
	db.open_db()
	for item_id in new_items:
		db.insert_row("player_item_inventory", {"player_id": player_id, "item_id" : item_id})
	new_items.clear()
	for grid_item in dropped_grid:
		db.delete_rows("grid_square", "item_id = " + var_to_str(grid_item["item_id"]) + " AND player_id = " + var_to_str(grid_item["player_id"]))
	dropped_grid.clear()
	for grid_item in new_grid:
		db.insert_row("grid_square", {"x_pos": grid_item["x"], "y_pos": grid_item["y"], "player_id": player_id, "item_id" : grid_item["item_id"]})
	new_grid.clear()
	
	inventory.clear()
	grid.clear()
	grid.resize(32)
	grid.fill({"x":-1,"y":-1})
	for item in db.select_rows("player_item_inventory", "player_id = " + var_to_str(player_id), ["item_id"]):
		inventory.push_back(item["item_id"])
	for grid_item in db.select_rows("grid_square", "player_id = " + var_to_str(player_id), ["x_pos", "y_pos", "item_id"]):
		grid[grid_item["item_id"]] = {"x": grid_item["x_pos"], "y": grid_item["y_pos"]}
	db.close_db()

func get_item_data(item_ids : Array):
	var items : Array
	db.open_db()
	var query_string = "SELECT hex(data) FROM item WHERE item_id = ?;"
	for item_id in item_ids:
		db.query_with_bindings(query_string, [item_id])
		items.push_back(db.query_result[0]["hex(data)"].hex_decode())
	db.close_db()
	return items

func add_items(item_ids : Array):
	for item_id in item_ids:
		new_items.push_back(item_id)
		if (!inventory.find(item_id)):
			inventory.push_back(item_id)

func add_grid(grid_tiles : Array):
	print("ADDING")
	for item in grid_tiles:
		new_grid.push_back(item)
		if (!grid.find(item)):
			grid[item["item_id"]] = {"x":item["x"], "y":item["y"]}

func pop_grid(grid_tiles : Array):
	print("POPPING")
	for item in grid_tiles:
		grid[item["item_id"]] = {"x":-1, "y":-1}
		dropped_grid.push_back({"item_id": item["item_id"], "player_id": player_id})


extends Node2D

@export var tile : PackedScene

var tile_array : Array

const upgrades_grid = preload("res://upgrades_grid.gd")

func load_tiles():
	upgrades_grid.load_grid()
	var tile_count = 0
	for tile_id in db.inventory:
		var tile_name = "tile_" + var_to_str(tile_id)
		var new_tile_scene
		new_tile_scene = tile.instantiate()
		new_tile_scene.set_name(tile_name)
		add_child(new_tile_scene)
		new_tile_scene.position = Vector2(20 * (tile_count % 6) + 50, 100 * floor(tile_count / 6) + 150 + (50 * floor(tile_count/6)))
		new_tile_scene.load_position = new_tile_scene.position
		if db.grid[tile_id]["x"] != -1:
			new_tile_scene.position = Vector2((Globals.GRID_X + 20 + (40 * db.grid[tile_id]["x"])),(Globals.GRID_Y + 20 + (40 * db.grid[tile_id]["y"])))
			new_tile_scene.in_grid = true
		new_tile_scene.generate_tile(tile_id)
		new_tile_scene.render_tiles()
		tile_array.push_back(tile_name)
		tile_count += 1


func _on_ready():
	load_tiles()

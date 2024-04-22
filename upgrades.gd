extends Node2D

@export var tile : PackedScene

var tile_array : Array

const upgrades_grid = preload("res://upgrades_grid.gd")
var buff_array

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
		new_tile_scene.generate_tile(tile_id)
		new_tile_scene.render_tiles()
		if db.grid[tile_id]["x"] != -1:
			new_tile_scene.position = Vector2((Globals.GRID_X + 20 + (40 * db.grid[tile_id]["x"])),(Globals.GRID_Y + 20 + (40 * db.grid[tile_id]["y"])))
			new_tile_scene.in_grid = true
			upgrades_grid.set_tile_grid_spot(Vector2(db.grid[tile_id]["x"], db.grid[tile_id]["y"]), new_tile_scene.bitmap, tile_id)
		tile_array.push_back(tile_name)
		tile_count += 1


func _on_ready():
	load_tiles()
	upgrades_grid.get_tile_buffs()
	buff_array = upgrades_grid.tile_upgrades
	set_text()

func _process(delta):
	upgrades_grid.get_tile_buffs()
	if buff_array == upgrades_grid.tile_upgrades:
		return
	buff_array = upgrades_grid.tile_upgrades
	set_text()
	
func set_text():
	var text_label = "Current buffs:\n"
	var base_damage = "Base Damage: {x}\n".format({"x": 1 + (0.5*buff_array[2])})
	var melee_damage = "Melee Damage: {x}\n".format({"x": 1 + (0.5*buff_array[1])})
	var ranged_damage = "Ranged Damage: {x}\n\n".format({"x": 1 + (0.5*buff_array[0])})
	var melee_range = "Melee Range: {x}\n".format({"x": 64 + (2*buff_array[3])})
	var ranged_speed = "Ranged Speed: {x}\n".format({"x": 100+(10*buff_array[4])})
	var melee_cooldown = "Melee Cooldown: {x}s\n".format({"x": 1-(0.1 * buff_array[6])})
	var ranged_cooldown = "Ranged Cooldown: {x}s\n".format({"x": 1-(0.1*buff_array[7])})
	var hp_amt = "HP: {x}".format({"x":5 + (0.5 * buff_array[7])})
	$RichTextLabel.set_text(text_label + base_damage + melee_damage + ranged_damage + melee_range + melee_cooldown + ranged_speed + ranged_cooldown)

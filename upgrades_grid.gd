extends Node

static var grid_field : Array
static var tile_upgrades : Array

static func load_grid():
	grid_field = []
	for x in Globals.GRID_SIZE / 40:
		var grid_row : Array
		for y in Globals.GRID_SIZE / 40:
			grid_row.push_back(-1)
		grid_field.push_back(grid_row)
	print(grid_field)


static func check_tile_grid_spot(grid_spot: Vector2, bitmap : int):
	# Returns true if tile doesn't overlap with another on grid
	print("checking")
	print(grid_field)
	for y in 4:
		for x in 4:
			if bitmap & 0x1:
				if (grid_spot.x + x > 3) or (grid_spot.y + y > 3) or (grid_spot.x + x < 0) or (grid_spot.y + y < 0): #if one tile is outside grid
					print("fail on outside")
					return false
				if grid_field[grid_spot.x + x][grid_spot.y + y] != -1: #if grid spot is occupied
					print("fail on occupied: " + var_to_str(grid_spot.x) + "+" + var_to_str(x) + ", " + var_to_str(grid_spot.y) + "+" + var_to_str(y))
					return false
			bitmap = bitmap >> 1
	return true

static func set_tile_grid_spot(grid_spot : Vector2, bitmap : int, tile_id : int):
	print("setting")
	for y in 4:
		for x in 4:
			if bitmap & 0x1:
				print("SET: " + var_to_str(grid_spot.x) + "+" + var_to_str(x) + ", " + var_to_str(grid_spot.y) + "+" + var_to_str(y))
				grid_field[grid_spot.x + x][grid_spot.y + y] = tile_id
			bitmap = bitmap >> 1
	db.add_grid([{"x": grid_spot.x, "y": grid_spot.y, "item_id": tile_id}])
	print(grid_field)

static func clear_tile_grid_spot(grid_spot : Vector2, bitmap : int, tile_id: int):
	print("clearing")
	for y in 4:
		for x in 4:
			if bitmap & 0x1:
				grid_field[grid_spot.x + x][grid_spot.y + y] = -1
			bitmap = bitmap >> 1
	db.pop_grid([{"x": grid_spot.x, "y": grid_spot.y, "item_id": tile_id}])
	print(grid_field)




static func get_tile_buffs():
	tile_upgrades = [0, 0, 0, 0, 0, 0, 0, 0]
	var tiles_in_grid = []
	for x in grid_field:
		for y in x:
			if (y != -1) and (tiles_in_grid.find(y) == -1):
				tiles_in_grid.push_back(y)
	
	var tile_data_array : Array = db.get_item_data(tiles_in_grid)
	for tile_data in tile_data_array:
		var buff_types = (tile_data.slice(3, 4).decode_u8(0))
		var buff_values = tile_data.slice(0, 3)
		
		for x in 8:
			if (buff_types & 0x1):
				tile_upgrades[x] += int(buff_values[-1])# & 0xFF
				buff_values = buff_values.slice(0, -1)
			buff_types = buff_types >> 1


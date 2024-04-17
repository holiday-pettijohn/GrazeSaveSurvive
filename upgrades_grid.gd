extends Node

static var grid_field : Array

static func load_grid():
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
	print(grid_field)

static func clear_tile_grid_spot(grid_spot : Vector2, bitmap : int):
	print("clearing")
	for y in 4:
		for x in 4:
			if bitmap & 0x1:
				grid_field[grid_spot.x + x][grid_spot.y + y] = -1
			bitmap = bitmap >> 1
	print(grid_field)


func get_tile_grid_spot(item_id : int):
	pass #TODO

extends Node2D

var SAMPLE_TILE_1 = 0x000205840131
# TILE DATA FORMAT:
# 6-byte BLOB in db
# [Buff3 Val] [Buff2 Val] [Buff1 Val] [Buff #s] [Bitmap] [Bitmap]
#
# Bitmap stores tile shape in 4x4 field
# 
# Buff #s: 8 possible buffs, 1-bit indicator for Buff1-3 (in order: 0x01 -> Buff1=Melee Dmg)
# Buf Vals: 0-255 multiplier to base buff, dependent on Buff #

var db : SQLite

var buffs = {}
var color = Color()

var tile_offset = Vector2i(40, 40)

# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = "res://database.sqlite3"
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#working
func render_tiles(bitmap):
	for y in 4:
		for x in 4:
			if (bitmap & 0x1):
				var tile_rect = ColorRect.new()
				tile_rect.position = Vector2(x*tile_offset[0], y*tile_offset[1])
				tile_rect.color = color
				tile_rect.custom_minimum_size.x = tile_offset[0]
				tile_rect.custom_minimum_size.y = tile_offset[1]
				tile_rect.visible = true
				add_child(tile_rect)
			bitmap = bitmap >> 1


func generate_tile(tile_id : int):
	# Pulls tile stats and sprite from db based on tile_id, renders tile
	# Pass (tile_id = -1) to select random tile (ie. for enemy death)
	
	if (tile_id == -1): # random tile selection
		tile_id = randi()%32
	
	#get tile data from db
	db.open_db()
	#db.verbosity_level = 3
	var query_string = "SELECT hex(data) FROM item WHERE item_id = ?;"
	var param_bindings = [tile_id]
	db.query_with_bindings(query_string, param_bindings)
	var tile_data = db.query_result[0]["hex(data)"].hex_decode() #store data into PackedByteArray
	db.close_db()
	
	
	var bitmap_data = tile_data.slice(-2)
	bitmap_data.reverse() # was having problems w/o doing this, endianness maybe?
	var bitmap = bitmap_data.decode_u16(0)
	
	var buff_types = (tile_data.slice(3, 4).decode_u8(0))
	var buff_values = tile_data.slice(0, 3)
	
	for x in 8:
		if (buff_types & 0x1):
			buffs[x] = int(buff_values[-1] & 0xFF)
			buff_values = buff_values.slice(0, -1)
		buff_types = buff_types >> 1
	
	# Can add color data to datatype later if desired
	color = Color(tile_data[3], tile_data[4], tile_data[5])
	render_tiles(bitmap)

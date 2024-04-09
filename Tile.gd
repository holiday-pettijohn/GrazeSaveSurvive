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


var tile_id : int = 0
var tile_data : PackedByteArray
var color = Color()

var tile_offset = Vector2i(40, 40)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_ready():
	tile_data = db.get_item_data([tile_id])[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func render_tiles():
	var bitmap_data = tile_data.slice(-2)
	bitmap_data.reverse() # was having problems w/o doing this, endianness maybe?
	var bitmap = bitmap_data.decode_u16(0)
	color = Color(tile_data[0], tile_data[1], tile_data[2])
	
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


func generate_tile(tile_id_input : int):
	# Pulls tile stats and sprite from db based on tile_id, renders tile
	# Pass (tile_id = -1) to select random tile (ie. for enemy death)
	
	if (tile_id_input == -1): # random tile selection
		tile_id = randi()%32
		#tile_offset = Vector2i(10, 10)
	else:
		tile_id = tile_id_input
	
	

func get_tile_buffs():
	var buff_types = (tile_data.slice(3, 4).decode_u8(0))
	var buff_values = tile_data.slice(0, 3)
	var buffs = {}
	
	for x in 8:
		if (buff_types & 0x1):
			buffs[x] = int(buff_values[-1] & 0xFF)
			buff_values = buff_values.slice(0, -1)
		buff_types = buff_types >> 1
	return buffs


func _on_area_entered(area):
	db.add_items([tile_id])
	queue_free() #Get ctrl-v'd


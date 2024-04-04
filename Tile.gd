extends Node2D

var SAMPLE_TILE_1 = 0x000205840131
var tile_data
# TILE DATA FORMAT:
# 6-byte BLOB in db
# [Buff3 Val] [Buff2 Val] [Buff1 Val] [Buff #s] [Bitmap] [Bitmap]
#
# Bitmap stores tile shape in 4x4 field
# 
# Buff #s: 8 possible buffs, 1-bit indicator for Buff1-3 (in order: 0x01 -> Buff1=Melee Dmg)
# Buf Vals: 0-255 multiplier to base buff, dependent on Buff #

var buffs = {}
var color = Color()

var tile_offset = Vector2i(40, 40)

# Called when the node enters the scene tree for the first time.
func _ready():
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func generate_tile(tile_id):
	if (tile_id == -1):
		tile_id = randi()%32
	
	#get tile data from db
	tile_data = SAMPLE_TILE_1
	
	var bitmap = (tile_data & 0xFFFF)
	tile_data = tile_data >> 16
	
	var buff_types = (tile_data & 0xFF)
	tile_data = tile_data >> 8
	
	for x in 8:
		if (buff_types & 0x1):
			buffs[x] = int(tile_data & 0xFF)
			tile_data = tile_data >> 8
			#print(x)
			#print(buffs[x])
		buff_types = buff_types >> 1
	
	# Can add color data to datatype later if desired
	color = Color(randf(), randf(), randf())
	render_tiles(bitmap)

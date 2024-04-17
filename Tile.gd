extends CollisionObject2D

var SAMPLE_TILE_1 = 0x000205840131
# TILE DATA FORMAT:
# 6-byte BLOB in db
# [Buff3 Val] [Buff2 Val] [Buff1 Val] [Buff #s] [Bitmap] [Bitmap]
#
# Bitmap stores tile shape in 4x4 field
# 
# Buff #s: 8 possible buffs, 1-bit indicator for Buff1-3 (in order: 0x01 -> Buff1=Melee Dmg)
# Buf Vals: 0-255 multiplier to base buff, dependent on Buff #

const TILE_SIZE = 40

var tile_id : int = 0
var tile_data : PackedByteArray
var bitmap
var pickable = false
var in_grid = false

var tile_offset = Vector2i(TILE_SIZE, TILE_SIZE)

const upgrades_grid = preload("res://upgrades_grid.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_ready():
	pass


func render_tiles():
	var bitmap_data = tile_data.slice(-2)
	bitmap_data.reverse() # was having problems w/o doing this, endianness maybe?
	bitmap = bitmap_data.decode_u16(0)
	var load_bitmap = bitmap
	
	for y in 4:
		for x in 4:
			if (load_bitmap & 0x1):
				var tile_rect = Sprite2D.new()
				tile_rect.position = Vector2(x*tile_offset[0], y*tile_offset[1])
				tile_rect.set_texture($TheTheSprite.texture)
				tile_rect.visible = true
				add_child(tile_rect)
				
				var tile_grab = CollisionShape2D.new()
				tile_grab.position = Vector2(x*tile_offset[0], y*tile_offset[1])
				tile_grab.debug_color = Color(0, 200, 0, 1)
				tile_grab.shape = RectangleShape2D.new()
				tile_grab.shape.size = Vector2(tile_offset[0], tile_offset[1])
				add_child(tile_grab)
				
			load_bitmap = load_bitmap >> 1


func generate_tile(tile_id_input : int):
	# Pulls tile stats and sprite from db based on tile_id, renders tile
	# Pass (tile_id = -1) to select random tile (ie. for enemy death)
	
	if (tile_id_input == -1): # random tile selection
		tile_id = randi()%32
		#tile_offset = Vector2i(10, 10)
	else:
		tile_id = tile_id_input
		pickable = true
	
	tile_data = db.get_item_data([tile_id])[0]


func _on_area_entered(area):
	db.add_items([tile_id])
	queue_free() #Get ctrl-v'd



var mouse_in = false
var clicked = false
var grabbed_offset = Vector2()
var grid_position = Vector2()
var load_position = Vector2()

func _process(delta):
	if pickable and Input.is_action_pressed("click"):
		if mouse_in and !clicked and Globals.get_grab_lock():
			clicked = true
			grabbed_offset = position - get_global_mouse_position()
			z_index = 1
			if in_grid:
				upgrades_grid.clear_tile_grid_spot(grid_position, bitmap)
				in_grid = false
		if clicked:
			position = get_global_mouse_position() + grabbed_offset
	elif clicked:
		clicked = false
		z_index = 0
		Globals.release_grab_lock()
		if pos_in_grid():
			var snap_position = Vector2((position.x - (int(position.x) % 40) + (40 - (Globals.GRID_X % 40))), (position.y - (int(position.y) % 40) + (40 - (Globals.GRID_Y % 40))))
			grid_position = Vector2((snap_position.x - Globals.GRID_X - 20) / 40, (snap_position.y - Globals.GRID_Y - 20) / 40)
			if upgrades_grid.check_tile_grid_spot(grid_position, bitmap): #grid empty AND in-bounds
				position = snap_position
				upgrades_grid.set_tile_grid_spot(grid_position, bitmap, tile_id)
				in_grid = true
			else:
				position = load_position

func _on_mouse_entered():
	grabbed_offset = position - get_global_mouse_position()
	mouse_in = true

func _on_mouse_exited():
	mouse_in = false


func pos_in_grid():
	return position.x >= (Globals.GRID_X) && position.x <= (Globals.GRID_X + Globals.GRID_SIZE) && position.y >= (Globals.GRID_Y) && position.y <= (Globals.GRID_Y + Globals.GRID_SIZE)

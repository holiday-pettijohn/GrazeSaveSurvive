extends Node2D

@export var tile : PackedScene


var grid_field = [[-1,-1,-1,-1,-1],[-1,-1,-1,-1,-1],[-1,-1,-1,-1,-1],[-1,-1,-1,-1,-1],[-1,-1,-1,-1,-1]]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func load_tiles():
	print(db.inventory)
	for tile_id in db.inventory:
		print(tile_id)
		var new_tile_scene
		new_tile_scene = tile.instantiate()
		add_child(new_tile_scene)
		new_tile_scene.position = Vector2(10*tile_id["item_id"], 100)
		new_tile_scene.generate_tile(tile_id["item_id"])
		new_tile_scene.render_tiles()


func _on_ready():
	load_tiles()

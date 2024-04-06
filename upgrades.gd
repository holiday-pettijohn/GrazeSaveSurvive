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
	for tile_id in db.inventory:
		var new_tile_scene
		new_tile_scene = tile.instantiate()
		new_tile_scene.generate_tile(tile_id["item_id"])
		add_child(new_tile_scene)
		new_tile_scene.render_tiles()


func _on_ready():
	load_tiles()

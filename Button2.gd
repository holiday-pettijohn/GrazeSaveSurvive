extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().change_scene_to_file("res://options menu.tscn") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	get_tree().quit()


func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index ("Master"), value) # Replace with function body.

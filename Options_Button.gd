extends Button
@onready var selectsfx = $SelectSound


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_options_pressed():
	get_tree().change_scene_to_file("res://options menu.tscn")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

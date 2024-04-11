extends Button
@onready var selectsfx = $SelectSound


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../StartRunButton".grab_focus()


func _on_options_pressed():
	#var options_menu = load("res://options_menu.tscn").instance()
	#get_tree().current_scene.add_child(options_menu)
	get_tree().change_scene_to_file("res://options_menu.tscn")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

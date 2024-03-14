extends Button



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_run_pressed():
	get_tree().change_scene_to_file("res://run.tscn")
	#$"../../SelectSound".play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (Input.is_key_pressed(KEY_R)):
		_on_run_pressed()


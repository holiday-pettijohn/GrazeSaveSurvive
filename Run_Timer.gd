extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	set_one_shot(true)
	set_wait_time(600)
	start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (is_stopped()):
		#Display results screen scene
		get_tree().change_scene("res://results.tscn")
		pass
	

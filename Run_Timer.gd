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
		var root = get_tree().root
		var level = root.get_node("Run")
		root.remove_child(level)
		level.call_deferred("free")
		var next_level_resource = load("res://results.tscn")
		var next_level = next_level_resource.instantiate()
		root.add_child(next_level)
		pass
	

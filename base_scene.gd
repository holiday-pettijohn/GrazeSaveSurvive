extends Node

@export var wave_count = 1;
@export var enemy_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_game():
	$Player.start($StartPosition.position)
	updateWaveDisplay()
	initializeWaves()
	
func game_over():
	$WaveTimer.stop()

func _on_wave_timer_timeout():
	#Spawn enemies
	var enemycount = 4 + wave_count #More enemies spawn per wave
	var c = enemycount
	
	while (c > 0):
		var newEnemy = enemy_scene.instantiate()
		newEnemy.position.x = get_viewport().size.x * int(c <= enemycount / 2) #Half spawn on left and right
		newEnemy.position.y = randi_range(0, get_viewport().size.y)
		
		#Set direction - I AM FIGURING IT OUT
		#var direction = atan2($Player.position.y - newEnemy.position.y, $Player.position.x - newEnemy.position.x)
		#newEnemy.rotation = direction
		#var velocity = Vector2(25.0, 0.0)
		#newEnemy.linear_velocity = velocity.rotated(direction)
		
		add_child(newEnemy)
		
		
		c -= 1
		
	wave_count += 1
	setWaitTime()
	updateWaveDisplay()

func setWaitTime():
	#Waves get longer
	$WaveTimer.wait_time = 15*wave_count

func initializeWaves():
	setWaitTime()
	$WaveTimer.start()
	
func updateWaveDisplay():
	$WaveDisplay/displayWaveCount.text = "Wave: " + str(wave_count)
	$WaveDisplay/displayWaveTime.text = str($WaveTimer.time_left) + "s"

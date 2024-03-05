extends Node

@export var wave_count = 0
var wave_duration : int
var wave_timeleft : int
@export var enemy_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_game():
	$Player.start($StartPosition.position)
	wave_duration = 5 #Start with 5 second rest
	wave_timeleft = wave_duration
	updateWaveDisplay()
	$WaveTimer.start()
	
func game_over():
	$WaveTimer.stop()
	$GameOverTimer.start()
	
func _on_game_over_timer_timeout():
	get_tree().change_scene_to_file("res://results.tscn")

func _on_wave_timer_timeout():
	wave_timeleft -= 1
	
	if (wave_timeleft <= 0):
		spawnWave()
		
		wave_count += 1
		setWaveTimer() #Reset timer
		wave_timeleft = wave_duration
		
	updateWaveDisplay()

func setWaveTimer():
	wave_duration = (15*wave_count) + 5 #Waves get longer
	
func updateWaveDisplay():
	var text_secs = "0"
	var text_mins = "" #The string will be populated if mins > 0
	text_secs = str(wave_timeleft % 60) + "s"
	
	var mins = int(wave_timeleft / 60) #Truncated
	if (mins > 0):
		text_mins = str(mins) + "m"

	$WaveDisplay/displayWaveCount.text = "Wave: " + str(wave_count)
	$WaveDisplay/displayWaveTime.text = text_mins + text_secs

func spawnWave():
	#Spawn enemies
	var enemycount = 4 + wave_count #More enemies spawn per wave
	var c = enemycount
	
	while (c > 0):
		var newEnemy = enemy_scene.instantiate()
		var spawnPosition = Vector2.ZERO
		spawnPosition.x = get_viewport().size.x * int(c <= enemycount / 2) #Half spawn on left and right
		spawnPosition.y = randi_range(0, get_viewport().size.y)
		newEnemy.position = spawnPosition
		
		add_child(newEnemy)
		c -= 1

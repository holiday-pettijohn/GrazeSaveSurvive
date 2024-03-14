extends Node

@export var wave_count = 0
var wave_duration : int
var wave_timeleft : int
var total_time : int
@export var enemy_scene : PackedScene

#Tracking the camera
var vport; var cam

# Called when the node enters the scene tree for the first time.
func _ready():
	#Get viewport and camera
	vport = get_viewport()
	cam = vport.get_camera_2d()
	start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_game():
	#Player starts in middle of screen
	$StartPosition.position = Vector2(Globals.MAP_WIDTH / 2, Globals.MAP_HEIGHT / 2)
	$Player.start($StartPosition.position)
	wave_duration = 5 #Start with 5 second rest
	wave_timeleft = wave_duration
	updateWaveDisplay()
	$WaveTimer.start()
	
func game_over():
	$WaveTimer.stop()
	$ParallaxBackground/Results.show()

func _on_wave_timer_timeout():
	wave_timeleft -= 1
	total_time += 1
	
	if (wave_timeleft <= 0):
		spawnWave()
		
		wave_count += 1
		setWaveTimer() #Reset timer
		wave_timeleft = wave_duration
		
	updateWaveDisplay()
	updateGlobalTimeDisplay()

func setWaveTimer():
	wave_duration = (15*wave_count) + 5 #Waves get longer
	
func updateWaveDisplay():
	var text_secs = "0"
	var text_mins = "" #The string will be populated if mins > 0
	text_secs = str(wave_timeleft % 60) + "s"
	
	var mins = int(wave_timeleft / 60) #Truncated
	if (mins > 0):
		text_mins = str(mins) + "m"

	$ParallaxBackground/WaveDisplay/displayWaveCount.text = "Wave: " + str(wave_count)
	$ParallaxBackground/WaveDisplay/displayWaveTime.text = text_mins + text_secs

func spawnWave():
	#Spawn enemies
	var enemycount = 4 + wave_count #More enemies spawn per wave
	var c = enemycount
	
	while (c > 0):
		#Get an offscreen spawn position
		var cam_rect = getCameraBounds() #x1x2, x2y2
		var rand_ypos = randi_range(0, Globals.MAP_HEIGHT) #Random y
		
		var rand_xpos = randi_range(0, Globals.MAP_WIDTH  - vport.size.x) #Random x OUTSIDE CAMERA
		if (rand_xpos >= cam_rect[0].x):
			rand_xpos += vport.size.x
		
		var spawnPosition = Vector2(rand_xpos, rand_ypos)
		
		#Create enemy
		var newEnemy = enemy_scene.instantiate()
		newEnemy.position = spawnPosition
		
		add_child(newEnemy)
		c -= 1

func getCameraBounds():
	#Returns an array of 2 vectors: [0] x1y1 and [1] x2y2
	var cam_centerpos = cam.get_screen_center_position()
	var cam_x1y1 = Vector2(cam_centerpos.x - (vport.size.x / 2), cam_centerpos.y - (vport.size.y / 2))
	var cam_x2y2 = Vector2(cam_centerpos.x + (vport.size.x / 2), cam_centerpos.y + (vport.size.y / 2))
	var cam_rect = [cam_x1y1,cam_x2y2]
	return cam_rect

func updateGlobalTimeDisplay():
	var text_secs = "0"
	var text_mins = "" #The string will be populated if mins > 0
	text_secs = str(total_time % 60) + "s"
	
	var mins = int(total_time / 60) #Truncated
	if (mins > 0):
		text_mins = str(mins) + "m"
	$ParallaxBackground/GlobalTimeDisplay/displayGlobalTime.text = "Time: " + text_mins + text_secs


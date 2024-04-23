extends Node

@export var wave_count = 0
var wave_duration : int
var wave_timeleft : int
var total_time : int
var game_started: bool

@export var enemy_melee_scene : PackedScene
@export var enemy_ranged_scene : PackedScene

@onready var lvl1music = $"Music/Lvl1Music"
@onready var lvl2music = $"Music/Lvl2Music"
@onready var lvl3music = $"Music/Lvl3Music"
@onready var bossBuildTune = $"Music/Boss BuildupMusic"
@onready var deathmusic = $"Music/DeathMusic"

#Tracking the camera
var vport; var cam

var kills

var win

signal game_end

# Called when the node enters the scene tree for the first time.
func _ready():
	#Get viewport and camera
	vport = get_viewport()
	cam = vport.get_camera_2d()
	start_game()
	kills = 0
	win = false
	game_started = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Player.hp != null:
		$UI/StatsBar/HealthBar.value = int(100*(float($Player.hp)/$Player.MAX_HP))
	if $Player.xp != null:
		$UI/StatsBar/XPBar.value = int(100*(float($Player.xp)/$Player.level_threshold($Player.level)))

func start_game():
	#Player starts in middle of screen
	$StartPosition.position = Vector2(Globals.MAP_WIDTH / 2, Globals.MAP_HEIGHT / 2)
	$Player.start($StartPosition.position)
	game_end.connect($UI/Results.game_end)
	wave_duration = 5 #Start with 5 second rest
	wave_timeleft = wave_duration
	updateWaveDisplay()
	updateGlobalTimeDisplay()
	$WaveTimer.start()
	lvl1music.play()

func _on_player_death():
	game_over()
	game_end.emit()

func game_over():
	lvl1music.stop()
	lvl2music.stop()
	lvl3music.stop()
	bossBuildTune.stop()
	$WaveTimer.stop()
	$UI/Results.final_level = $Player.level
	$UI/Results.final_kills = kills
	$UI/Results.win = win
	$UI/Results.show()

func _on_wave_timer_timeout():
	wave_timeleft -= 1
	total_time += 1

	if (wave_timeleft <= 0 and wave_count <= 10):
		spawnWave()

		wave_count += 1
		setWaveTimer() #Reset timer
		updateMusic()
		wave_timeleft = wave_duration
		
	elif wave_count == 11:
		win = 1
		game_over()
		game_end.emit() #Spawn big enemy instance? Otherwise win
	
	updateWaveDisplay()
	updateGlobalTimeDisplay()

func updateMusic():
	if (wave_count == 2):
		lvl1music.stop()
		lvl2music.play()
		
	if (wave_count == 5):
		lvl2music.stop()
		bossBuildTune.play()

	if (wave_count == 6):
		bossBuildTune.stop()
		lvl3music.play()

func setWaveTimer():
	wave_duration = 16 + wave_count #Waves get a little longer

func updateWaveDisplay():
	var text_secs = "0"
	var text_mins = "" #The string will be populated if mins > 0
	text_secs = str(wave_timeleft % 60) + "s"

	var mins = int(wave_timeleft / 60) #Truncated
	if (mins > 0):
		text_mins = str(mins) + "m"

	#$UI/WaveDisplay/displayWaveCount.text = "Wave: " + str(wave_count)
	#$UI/WaveDisplay/displayWaveTime.text = text_mins + text_secs
	$UI/WaveDisplay/HBoxContainer/AnimatedSprite2D.play(str(wave_count))

func spawnWave():
	#Spawn enemies
	var melee_count = 10 + wave_count**1.2 #Funny enemy scaling go brr
	var ranged_count = 10 + wave_count**1.2
	# In all seriousness, this does highlight an issue with no enemy collision
	# What should we do about this?
	var total_count = melee_count + ranged_count

	while (total_count > 0):
		#Get an offscreen spawn position
		var cam_rect = getCameraBounds() #x1x2, x2y2
		var rand_ypos = randi_range(0, Globals.MAP_HEIGHT) #Random y

		var rand_xpos = randi_range(0, Globals.MAP_WIDTH  - vport.size.x) #Random x OUTSIDE CAMERA
		if (rand_xpos >= cam_rect[0].x):
			rand_xpos += vport.size.x

		var spawnPosition = Vector2(rand_xpos, rand_ypos)

		#Create enemy
		var newEnemy
		if (melee_count > 0):
			newEnemy = enemy_melee_scene.instantiate()
			newEnemy.connect("death", increment_kills)
			newEnemy.MAX_HP += randi_range(0, wave_count/2)
			newEnemy.hp = newEnemy.MAX_HP
			newEnemy.DMG_CONTACT *= wave_count/2
			melee_count -= 1
		else:
			newEnemy = enemy_ranged_scene.instantiate()
			newEnemy.connect("death", increment_kills)
			newEnemy.RANGED_VELOCITY_MULT = randf_range(1.0, 1.5+0.5*wave_count)
			newEnemy.MAX_HP += randi_range(0, wave_count/2)
			newEnemy.hp = newEnemy.MAX_HP
			newEnemy.DMG_RANGED *= wave_count/2
			ranged_count -= 1

		newEnemy.position = spawnPosition

		game_end.connect(newEnemy.game_end)
		add_child(newEnemy)
		total_count -= 1

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
	$UI/GlobalTimeDisplay/displayGlobalTime.text = "Time elapsed: " + text_mins + text_secs

func increment_kills():
	kills += 1


func gain_xp(amount):
	$Player.gain_xp(amount)


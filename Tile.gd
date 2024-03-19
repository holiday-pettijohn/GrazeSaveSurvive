extends Node2D

var num_subtiles
var num_stats
var stat_total

var stat_partition = Array()

var sub_tiles = Array()
var tile_objects = Array()

var stat_bonuses = {}

# TODO: Move this to globals
var bonus_distribution = {
	"RANGE_ATK": 10,
	"MELEE_ATK": 10,
	"GEN_ATK": 2,
	"ATK_LVL": 1,
	"ATK_AREA": 3,
	"PROJ_SPEED": 3,
	"COOLDOWN": 1,
	"HP_ADD": 7,
	"HP_LVL": 5,
	"DEF_ADD": 5,
	"DEF_LVL": 1
}

# Stat point cost for each unit of a given buff
var stat_cost = {
	"RANGE_ATK": 1,
	"MELEE_ATK": 1,
	"GEN_ATK": 2,
	"ATK_LVL": 5,
	"ATK_AREA": 5,
	"PROJ_SPEED": 5,
	"COOLDOWN": 10,
	"HP_ADD": 2,
	"HP_LVL": 5,
	"DEF_ADD": 2,
	"DEF_LVL": 5
}

var tile_offset = Vector2i(40, 40)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func generate_random():
	generate_random_tiles()
	generate_random_stats()
	render_tiles()
	
func generate_random_tiles():
	sub_tiles.push_back(Vector2i(0, 0))
	# 1: 0-16, 2: 17:23, 3: 24:29, 4:30:31, 5: 32
	num_subtiles = randi() % 32
	if num_subtiles in range(0, 16):
		num_subtiles = 1
	elif num_subtiles in range(16, 24):
		num_subtiles = 2
	elif num_subtiles in range(24, 30):
		num_subtiles = 3
	elif num_subtiles in range(30, 31):
		num_subtiles = 4
	elif num_subtiles == 32:
		num_subtiles = 5
	else:
		num_subtiles = 1
		
	if num_subtiles != 1:
		for i in range(2, num_subtiles):
			var selections = Array()
			for t in sub_tiles:
				for d in [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)]:
					var tile_candidate = t+d
					if tile_candidate not in sub_tiles:
						selections.push_back(tile_candidate)
			sub_tiles.push_back(selections[randi()%selections.size()])
			
func generate_random_stats():
	#Base stat total randomly deviates +-15%
	stat_total = (num_subtiles*10 + pow(num_subtiles, 1.5))*(.85+(randi()%30)/100)
	num_stats = randi() % num_subtiles
	if num_stats in range(0, 2):
		num_stats = 1
	elif num_stats in range(2, 4):
		num_stats = 2
	elif num_stats in range(4, 5):
		num_stats = 3
	#TODO: add code to implement
	#Get sum of bonus_distribution and assign stats based on that
	#Each stat gets 1/num_stats +- 1/(4*num_stats) of the base total
	
	var stat_bonuses_total = 0
	for v in bonus_distribution.values():
		stat_bonuses_total += v
	
	var last_stat_partition = 0
	for i in range(0, num_stats-1):
		if num_stats > 1:
			stat_partition.push_back(1/num_stats + (-1/(4*num_stats)+(1/2)*(randi()%32)/32))
			
		var stat_bonus = randi()%stat_bonuses_total
		
		var stat_bonus_track = 0
		for b in bonus_distribution:
			# if we are on the first or last iteration of the loop, modify logic accordingly
			if b == "RANGE_ATK" and 0 <= stat_bonus and stat_bonus < bonus_distribution[b]:
				stat_bonus = b
				break
			elif b == "DEF_LVL" and stat_bonus_track+bonus_distribution[b] < stat_bonus:
				stat_bonus = b
				break
			elif stat_bonus_track <= stat_bonus and stat_bonus < stat_bonus_track+bonus_distribution[b]:
				stat_bonus = b
				break
			else:
				stat_bonus_track += bonus_distribution[b]
		
		if num_stats > 1:
			stat_bonuses[stat_bonus] = (stat_partition[-1]-last_stat_partition)/stat_cost[stat_bonus]
		else:
			stat_bonuses[stat_bonus] = stat_total/stat_cost[stat_bonus]
	
func render_tiles():
	for t in sub_tiles:
		var tile_rect = $BaseRect.instantiate()
		tile_rect.position = Vector2(t[0]*tile_offset[0], t[1]*tile_offset[1])
		tile_rect.visible = true
		tile_objects.push_back(tile_rect)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func generate_tile(power):
	pass

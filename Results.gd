extends Node2D

var final_level
var final_kills

# Called when the node enters the scene tree for the first time.
func _ready():
	final_level = 0
	final_kills = 0
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ResultsText.set_text("Final Level: %s\nKills: %i" % [final_level, final_kills])
	print("Final Level: %s\nKills: %d" % [final_level, final_kills])

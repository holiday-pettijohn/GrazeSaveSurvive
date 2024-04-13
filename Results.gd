extends Node2D

var final_level
var final_kills
var win


# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu.grab_focus()
	final_level = 0
	final_kills = 0
	win = false
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func game_end():
	var win_string = ""
	if (win):
		win_string = "You Won!\nThere are only 10 things a cow wants to do in life. Grazing and Surviving!"
	else:
		win_string = "Game Over...\nThere are only 10 things a cow wants to do in life. Dying is not one of them..."
	$ResultsText.set_text("Final Level: {l}\nKills: {k}\n{w}".format({"l": final_level, "k": final_kills, "w": win_string}))

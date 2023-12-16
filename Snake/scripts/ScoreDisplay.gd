## Made by Warnerm14
extends Label

func _process(_delta):
	text = "Score: " + str(GameControl.playerScore)

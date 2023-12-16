## Made by Warnerm14
extends Node

var playerScore = 0
var gameRunning = true
var pauseMenuUI = null
var playfieldTilemap = null
var pausedText = null
var gameOverText = null
var gameOverText2 = null
var resumeButton = null
var restartButton = null
var deathSoundScene = preload("res://sound/death_sound.tscn")
var pickupSoundScene = preload("res://sound/pickup_sound.tscn")

var defaultHeight = 20
var defaultWidth = 20

var currentHeight = defaultHeight
var currentWidth = defaultWidth

func _ready():
	var root = get_tree().get_root()
	pauseMenuUI = root.get_node("game/PauseMenu")
	playfieldTilemap = root.get_node("game/TileMap")
	
	pausedText = root.get_node("game/PauseMenu/PausedText")
	gameOverText = root.get_node("game/PauseMenu/GameOverText")
	gameOverText2 = root.get_node("game/PauseMenu/GameOverText2")
	resumeButton = root.get_node("game/PauseMenu/ResumeButton")
	restartButton = root.get_node("game/PauseMenu/RestartButton")
	
func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		if gameRunning:
			pauseGame(false,"")
		else:
			unpauseGame()

func playDeathSound():
	var deathSound = deathSoundScene.instantiate()
	add_child(deathSound)

func playPickupSound():
	var pickupSound = pickupSoundScene.instantiate()
	add_child(pickupSound)

func pauseGame(isGameOver,deathReason):
	gameRunning = false
	pauseMenuUI.visible = true
	if isGameOver:
		playfieldTilemap.modulate.a = 0
		pausedText.visible = false
		gameOverText.visible = true
		gameOverText2.visible = true
		gameOverText2.text = deathReason + "  Final Score: " + str(playerScore)
		resumeButton.visible = false
		restartButton.visible = true
		
		playDeathSound()
	else:
		playfieldTilemap.modulate.a = 0.2
		pausedText.visible = true
		gameOverText.visible = false
		gameOverText2.visible = false
		resumeButton.visible = true
		restartButton.visible = false
	
func unpauseGame():
	gameRunning = true
	pauseMenuUI.visible = false
	playfieldTilemap.modulate.a = 1

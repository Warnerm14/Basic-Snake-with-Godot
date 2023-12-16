## Made by Warnerm14
extends Control

@onready var heightText = get_node("NewGameText/HeightSlider/HeightText")
@onready var widthText = get_node("NewGameText/WidthSlider/WidthText")
@onready var heightSlider = get_node("NewGameText/HeightSlider")
@onready var widthSlider = get_node("NewGameText/WidthSlider")

var currentHeight = GameControl.currentHeight
var currentWidth = GameControl.currentWidth

func _ready():
	heightSlider.value = currentHeight
	widthSlider.value = currentWidth

func _process(_delta):
	heightText.text = ("Height: " + str(currentHeight))
	widthText.text = ("Width: " + str(currentWidth))
	currentHeight = heightSlider.value
	currentWidth = widthSlider.value

func _on_new_game_button_pressed():
	GameControl.currentHeight = heightSlider.value
	GameControl.currentWidth = widthSlider.value
	get_node("../TileMap").newGame()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_restart_button_pressed():
	get_node("../TileMap").newGame()

func _on_resume_button_pressed():
	GameControl.unpauseGame()

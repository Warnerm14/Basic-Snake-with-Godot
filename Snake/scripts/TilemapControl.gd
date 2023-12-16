## Made by Warnerm14
extends TileMap

var topLeftCord = [11,5]
var bottomRightCord = [topLeftCord[0] + GameControl.defaultWidth,topLeftCord[1] + GameControl.defaultHeight] #[60,36]
var snakeBodyArray = []
var timer = 0
var lastDir = "up"
var pressedInput = "up"
var lastPelletPos = Vector2i(-1,-1)

func _ready():
	GameControl.playerScore = 0
	createSnake()
	createPlayfield()
	placeNewPellet()

func _process(delta):
	timer += delta
	
	if Input.is_action_pressed("up"):
		pressedInput = "up"
	elif Input.is_action_pressed("down"):
		pressedInput = "down"
	elif Input.is_action_pressed("left"):
		pressedInput = "left"
	elif Input.is_action_pressed("right"):
		pressedInput = "right"
	
	if timer >= 0.2 and GameControl.gameRunning:
		timer = 0
		if pressedInput != lastDir:
			userInput(pressedInput)
		else:
			userInput("none")
	updateSnakeOnField()

func newGame():
	clear_layer(0)
	clear_layer(1)
	clear_layer(2)
	snakeBodyArray = []
	bottomRightCord = [topLeftCord[0] + GameControl.currentWidth,topLeftCord[1] + GameControl.currentHeight]
	lastPelletPos = Vector2i(-1,-1)
	lastDir = "up"
	timer = 0
	GameControl.unpauseGame()
	_ready()

func createPlayfield():
	clear_layer(0)
	for x in range(-40,120):
		for y in range(-40,120):
			set_cell(0, Vector2i(x,y), 0, Vector2i(2,0))
	
	for x in range(topLeftCord[0],bottomRightCord[0]):
		for y in range(topLeftCord[1],bottomRightCord[1]):
			set_cell(0, Vector2i(x,y), 0, Vector2i(1,0))

func addToSnakeArray(cords):
	snakeBodyArray.push_back(cords)

func updateSnakeOnField():
	clear_layer(1)
	for cords in snakeBodyArray:
		set_cell(1, cords, 0, Vector2i(0,0))

func moveSnakeTo(newCords):
	snakeBodyArray.push_front(newCords)
	snakeBodyArray.remove_at(snakeBodyArray.size() - 1)

func createSnake():
	var startingX = round((bottomRightCord[0] - topLeftCord[0]) / 2) + topLeftCord[0]
	var startingY = round((bottomRightCord[1] - topLeftCord[1]) / 2) + topLeftCord[1]
	addToSnakeArray(Vector2i(startingX,startingY))

func isOutOfBounds(checkCords):
	return (get_cell_atlas_coords(0,checkCords) == Vector2i(2,0))

func isSnake(checkCords):
	return (snakeBodyArray.has(checkCords))
		
func userInput(dir):
	var toMoveTilePos = null
	
	if dir == "none":
		dir = lastDir
	
	match dir:
		"up":
			toMoveTilePos = Vector2i(snakeBodyArray[0].x,snakeBodyArray[0].y - 1)
		"down":
			toMoveTilePos = Vector2i(snakeBodyArray[0].x,snakeBodyArray[0].y + 1)
		"left":
			toMoveTilePos = Vector2i(snakeBodyArray[0].x - 1,snakeBodyArray[0].y)
		"right":
			toMoveTilePos = Vector2i(snakeBodyArray[0].x + 1,snakeBodyArray[0].y)
	
	if isSnake(toMoveTilePos):
		if snakeBodyArray[1] == toMoveTilePos:
			userInput(lastDir)
			return
		else:
			GameControl.pauseGame(true,"You crashed into yourself!")
	elif isOutOfBounds(toMoveTilePos):
		GameControl.pauseGame(true,"You hit the wall!")
	else:
		moveSnakeTo(toMoveTilePos)
	
	lastDir = dir
	checkForPellet(toMoveTilePos)

func checkForPellet(checkPos):
	var pelletPos = (get_used_cells(2))[0]
	if checkPos == pelletPos:
		addToSnakeArray(checkPos)
		GameControl.playerScore += 1
		GameControl.playPickupSound()
		placeNewPellet()

func placeNewPellet():
	clear_layer(2)
	var x = randi_range(topLeftCord[0],bottomRightCord[0] - 1)
	var y = randi_range(topLeftCord[1],bottomRightCord[1] - 1)
	if not(Vector2i(x,y) in get_used_cells(1)) and (lastPelletPos != Vector2i(x,y)):
		set_cell(2, Vector2i(x,y), 0, Vector2i(3,0))
		lastPelletPos = Vector2i(x,y)
	else:
		placeNewPellet()

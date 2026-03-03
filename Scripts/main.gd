extends Node

@onready var background: ParallaxBackground = %Background
@onready var ground: StaticBody2D = %Ground
@onready var player: CharacterBody2D = %Player
@onready var camera: Camera2D = %Camera
@onready var hud: CanvasLayer = %HUD
@onready var gameover: CanvasLayer = %gameover
@onready var color_rect: ColorRect = %ColorRGB
@onready var timer: Timer = $Timer
@onready var crt: CanvasLayer = $CRT

@onready var audio_static: AudioStreamPlayer = %Audio_Static

var red = Color.from_rgba8(255, 0, 25, 40)  
var orange = Color.from_rgba8(255, 125, 0, 40)  
var blue = Color.from_rgba8(25, 115, 181, 40)  
 
var glitch_shader = preload("res://Art/Shaders/glitch_screen.gdshader")

var obst_high = preload("res://Scenes/Obstacles/obst_high.tscn")
var obst_low = preload("res://Scenes/Obstacles/obst_low.tscn")
var platform = preload("res://Scenes/Obstacles/platform.tscn")
var platform_blank = preload("res://Scenes/Obstacles/platform_blank.tscn")
var wall = preload("res://Scenes/Obstacles/wall.tscn")

var obstacles : Array
var platforms : Array
var obstacle_types := [obst_low, wall, wall, wall]
var platform_types := [platform, platform, platform, platform_blank]
var high_heights := [200, 390]

const MAX_DIFFICULTY : int = 2
var difficulty : int
const PLAYER_START_POS := Vector2(100, 485)
const PLAYER_START_POS_OFFSCREEN := Vector2(-50, 485)
const CAM_START_POS := Vector2(576, 324)
var speed : float
const START_SPEED : float = 3.0
const MAX_SPEED : float = 15.0
const SPEED_MODIFIER : int = 5000
var high_score : int
var screen_size : Vector2i
var ground_height : int
var score : int 
const SCORE_MODIFIER : int = 10
var last_obst
var last_platform
var rgb : int
var rand_obst : int
var rand_platform : int
var intro_finished : bool = false

func _ready() -> void:
	crt.show()
	rand_obst = randi_range(0,800)
	rand_platform = randi_range(0,800)
	player.change_collision_layer()
	timer.connect("timeout", stop_glitch)
	screen_size = get_window().size
	gameover.get_node("Button").pressed.connect(new_game)
	ground_height = ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	Global.game_over = false
	score = 0
	show_score()
	Global.game_running = false
	difficulty = 0
	get_tree().paused = false
	
	for obst in obstacles:
		obst.queue_free()
	obstacles.clear()
	
	player.position = PLAYER_START_POS_OFFSCREEN
	player.velocity = Vector2i(0,0)
	camera.position = CAM_START_POS
	ground.position = Vector2i(0,0)
	
	ui_visibility(false)
	gameover.hide()
	player.death_sprite_toggle()

func _process(_delta: float) -> void:
	
	match Global.rgb:  
			0: color_rect.color = Global.primary
			1: color_rect.color = Global.secondary
			2: color_rect.color = Global.tertiary
	
	if Global.game_running and !intro_finished:
		run_intro()
	
	if Global.game_running and intro_finished:
		
		score += speed
		show_score()
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		adjust_difficulty()
		
		generate_obst()
		generate_platform()
		
		player.position.x += speed
		camera.position.x += speed
		
		if camera.position.x - ground.position.x > screen_size.x * 1.5:
			ground.position.x += screen_size.x
		
		for obst in obstacles:
			if obst.position.x < (camera.position.x - screen_size.x):
				remove_obst(obst)
			
		if Input.is_action_just_pressed("r") and Global.rgb != 0: change_colour(0)
		if Input.is_action_just_pressed("g") and Global.rgb != 1: change_colour(1)
		if Input.is_action_just_pressed("b") and Global.rgb != 2: change_colour(2)
		
	else:
		if Input.is_action_just_pressed("ui_accept"):
			ui_visibility(true)
			Global.game_running = true

func show_score():
	hud.get_node("MarginContainer/ScoreContainer/Score").text = "SCORE: " + str(score/SCORE_MODIFIER)

func check_high_score():
	if score > high_score:
		high_score = score
		hud.get_node("MarginContainer/HighScore").text = "HIGH SCORE: " + str(high_score/SCORE_MODIFIER)

func generate_obst():
	if obstacles.is_empty() or last_obst.position.x < score + rand_obst:
		var obst_type = obstacle_types[randi() % obstacle_types.size()]
		var obst = obst_type.instantiate()
		var obst_height = obst.get_node("Sprite2D").texture.get_height()
		var obst_scale = obst.get_node("Sprite2D").scale
		var obst_x : int = screen_size.x + score + 100 + rand_obst
		var obst_y : int = screen_size.y - ground_height - (obst_height * obst_scale.y / 2) + 40
		last_obst = obst
		add_obst(obst, obst_x, obst_y)
		
		if difficulty > 0:
			if (randi()%2) == 0:
				obst = obst_high.instantiate()
				var obst_high_x : int = screen_size.x + score + 100
				var obst_high_y : int = high_heights[randi()%high_heights.size()]
				add_obst(obst, obst_high_x, obst_high_y)

func generate_platform():
	if platforms.is_empty() or last_platform.position.x < score + rand_platform:
		var platform_type = platform_types[randi() % platform_types.size()]
		var plat = platform_type.instantiate()
		plat.scale.x = plat.scale.x * randi_range(1,3)
		var platform_height = plat.get_node("Sprite2D").texture.get_height()
		var rand_height = randi_range(1,3)
		if rand_height > 1: rand_height -= 1
		var platform_scale = plat.get_node("Sprite2D").scale * rand_height
		var platform_x : int = screen_size.x + score + 100 + rand_platform
		var platform_y : int = screen_size.y - (-platform_height * platform_scale.y / 2) - ground_height - 180
		last_platform = plat
		plat.position = Vector2i(platform_x, platform_y)
		add_child(plat)
		platforms.append(plat)
		rand_platform = randi_range(0,800)

func add_obst(obst, x, y):
		obst.position = Vector2i(x, y)
		obst.body_entered.connect(hit_obst)
		add_child(obst)
		obstacles.append(obst)
		rand_obst = randi_range(0,800)

func remove_obst(obst):
	obst.queue_free()
	obstacles.erase(obst)

func hit_obst(body):
	if body.name == "Player":
		game_over()

func game_over():
	intro_finished = false
	Global.input_enabled = false
	Global.game_over = true
	check_high_score()
	Global.coins_total += Global.coins_collected
	Global.coins_collected = 0
	get_tree().paused = true
	Global.game_running = false
	gameover.show()
	player.death_sprite_toggle()
	
func change_colour(colour_index):
	audio_static.pitch_scale = randf_range(1.18, 1.22)
	audio_static.play()
	Global.rgb = colour_index
	var mat = ShaderMaterial.new()
	mat.shader = glitch_shader
	color_rect.material = mat
	timer.start()

func stop_glitch():
	color_rect.material = null

func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY: difficulty = MAX_DIFFICULTY

func ui_visibility(game_mode:bool):
	match game_mode:
		true:
			player.show()
			hud.get_node("MarginContainer/ScoreContainer").show()
			hud.get_node("MarginContainer/VBoxContainer").hide()
			hud.get_node("MarginContainer/ColourButtons").show()
			hud.get_node("MarginContainer/ShopButton").hide()
		false:
			player.hide()
			hud.get_node("MarginContainer/ScoreContainer").hide()
			hud.get_node("MarginContainer/VBoxContainer").show()
			hud.get_node("MarginContainer/ColourButtons").hide()
			hud.get_node("MarginContainer/ShopButton").show()

func run_intro():
	Global.input_enabled = false
	player.position.x += START_SPEED
	if player.position.x == PLAYER_START_POS.x:
		intro_finished = true
		Global.input_enabled = true
		

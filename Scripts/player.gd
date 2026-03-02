extends CharacterBody2D

const glitch_shader_red = preload("res://Art/Shaders/glitch_red.gdshader")
const glitch_shader_green = preload("res://Art/Shaders/glitch_green.gdshader")
const glitch_shader_blue = preload("res://Art/Shaders/glitch_blue.gdshader")

@onready var death_sprite: Sprite2D = %DeathSprite
@onready var anim: AnimatedSprite2D = %AnimatedSprite2D
@onready var run_col: CollisionShape2D = $RunCol
@onready var duck_col: CollisionShape2D = $DuckCol

const JUMP_SPEED : int = -1200
var canlongjump : bool

var jumping_part2 : bool = false

const GRAVITY : int = 6000
var gravity : int
const GRAV_MULT : float = 0.2
var grav_mult : float

func _ready() -> void:
	$Timer.connect("timeout", glitch_stop)

func _process(delta: float) -> void:
	
	if Global.game_running:
		if Input.is_action_just_pressed("r"):
			change_collision_layer()
			glitch(glitch_shader_red)
		if Input.is_action_just_pressed("g"):
			change_collision_layer()
			glitch(glitch_shader_green)
		if Input.is_action_just_pressed("b"):
			change_collision_layer()
			glitch(glitch_shader_blue)
	
	match Global.rgb:
		0: anim.modulate = Global.primary
		1: anim.modulate = Global.secondary
		2: anim.modulate = Global.tertiary

func _physics_process(delta: float) -> void:
	duck_col.disabled = !run_col.disabled
	if Global.input_enabled:
		velocity.y += gravity * delta
		if is_on_floor():
			jumping_part2 = false
			gravity = GRAVITY
			grav_mult = GRAV_MULT
			if !Global.game_running:
				anim.play("idle")
			else:
				run_col.disabled = false
				if Input.is_action_pressed("jump"):
					canlongjump = true
					velocity.y = JUMP_SPEED
				elif Input.is_action_pressed("duck"):
					run_col.disabled = true
					anim.play("duck")
				else:
					anim.play("run")
		else:
			if Input.is_action_pressed("jump") and canlongjump:
				gravity = GRAVITY * grav_mult
				grav_mult += 0.015
				if grav_mult > 1: grav_mult = 1
			if Input.is_action_just_released("jump"):
				canlongjump = false
				gravity = GRAVITY
			if anim.animation != "jump_start" and !jumping_part2:
				anim.play("jump_start")
	move_and_slide()

func glitch(shader_colour):
	var mat = ShaderMaterial.new()
	mat.shader = shader_colour
	anim.material = mat
	$Timer.start()

func glitch_stop():
	anim.material = null

func change_collision_layer():
	match Global.rgb:
		0: 
			set_collision_layer_value(2, false)
			set_collision_layer_value(3, true)
			set_collision_layer_value(4, true)
		1: 
			set_collision_layer_value(2, true)
			set_collision_layer_value(3, false)
			set_collision_layer_value(4, true)
		2: 
			set_collision_layer_value(2, true)
			set_collision_layer_value(3, true)
			set_collision_layer_value(4, false)

func _on_animated_sprite_2d_animation_finished() -> void:
	jumping_part2 = true
	if anim.animation == "jump_start":
		match randi_range(0,2):
			0: anim.play("jump1")
			1: anim.play("jump2")
			2: anim.play("jump3")

func death_sprite_toggle():
	if Global.game_over == true:
		death_sprite.show()
		anim.hide()
	else:
		death_sprite.hide()
		anim.show()

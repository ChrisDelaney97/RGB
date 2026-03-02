extends StaticBody2D

var rbg_index : int
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	pick_colour()
	change_collision()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("r") or Input.is_action_just_pressed("g") or Input.is_action_just_pressed("b"):
		change_collision()

func change_collision():
	if Global.rgb == rbg_index:
		collision_shape_2d.scale.y = 1
	else: 
		collision_shape_2d.scale.y = -1

func pick_colour():
	match randi_range(0,2):
		0:
			color_rect.color = Global.primary
			rbg_index = 0
		1:
			color_rect.color = Global.secondary
			rbg_index = 1
		2:
			color_rect.color = Global.tertiary
			rbg_index = 2

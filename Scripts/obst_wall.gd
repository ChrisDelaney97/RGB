extends Area2D

@onready var color_sprite: AnimatedSprite2D = $ColorSprite
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	pick_colour()

func pick_colour():
	match randi_range(0,2):
		0: 
			color_sprite.modulate = Global.primary
			set_collision_layer_value(2, true)
			set_collision_mask_value(2, true)
		1: 
			color_sprite.modulate = Global.secondary
			set_collision_layer_value(3, true)
			set_collision_mask_value(3, true)
		2: 
			color_sprite.modulate = Global.tertiary
			set_collision_layer_value(4, true)
			set_collision_mask_value(4, true)

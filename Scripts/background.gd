extends ParallaxBackground

@onready var sprite_2d: Sprite2D = $ParallaxLayer/Sprite2D

func _ready() -> void:
	sprite_2d.texture = Global.bg_art

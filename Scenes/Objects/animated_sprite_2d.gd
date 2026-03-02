extends AnimatedSprite2D

func _process(delta: float) -> void:
	if Global.game_over == false:
		show()
	else: hide()

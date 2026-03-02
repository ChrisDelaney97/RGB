extends Sprite2D

func _process(delta: float) -> void:
	if Global.game_over == true: show()
	else: hide()

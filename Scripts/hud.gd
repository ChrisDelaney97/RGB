extends CanvasLayer

@onready var primary_button: ColorRect = %PrimaryButton
@onready var secondary_button: ColorRect = %SecondaryButton
@onready var tertiary_button: ColorRect = %TertiaryButton
@onready var coins: Label = %Coins
@onready var total_coins: Label = %TotalCoins

var active = Color.from_rgba8(255, 255, 255, 255)  
var inactive = Color.from_rgba8(255, 255, 255, 60)  

func _process(delta: float) -> void:
	coins_text()
	colour_buttons()

func _on_shop_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Screens/shop.tscn")

func colour_buttons():
	
	primary_button.color = Global.primary
	secondary_button.color = Global.secondary
	tertiary_button.color = Global.tertiary
	
	match Global.rgb:
		0:
			primary_button.modulate = active
			secondary_button.modulate = inactive
			tertiary_button.modulate = inactive
		1:
			primary_button.modulate = inactive
			secondary_button.modulate = active
			tertiary_button.modulate = inactive
		2:
			primary_button.modulate = inactive
			secondary_button.modulate = inactive
			tertiary_button.modulate = active

func coins_text():
	coins.text = "COINS: " + str(Global.coins_collected)
	total_coins.text = "TOTAL COINS: " + str(Global.coins_total)

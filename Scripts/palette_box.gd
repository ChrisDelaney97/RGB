extends Control


@onready var button: Button = %Button
@onready var sold_out: Label = $SoldOut
@onready var equip: Button = %Equip
@onready var equip_container: MarginContainer = $EquipContainer
@onready var shadow: TextureRect = $Shadow

@export var shadow_texture : CompressedTexture2D
@export var price : int
@export var palette_index : int

const shine_shader = preload("res://Art/Shaders/shine.gdshader")

var purchased : bool
var equipped : bool

var active = Color.from_rgba8(50, 50, 50, 255)  
var inactive = Color.from_rgba8(255, 255, 255, 255)

func _ready() -> void:
	
	shadow.texture = shadow_texture
	
	match palette_index:
		1: purchased = Global.palette1_purchased
		2: purchased = Global.palette2_purchased
		3: purchased = Global.palette3_purchased
		4: purchased = Global.palette4_purchased
		5: purchased = Global.palette5_purchased
		6: purchased = Global.palette6_purchased
	
	visibilites()

func _on_button_mouse_entered() -> void:
	button.text = str(price) +  "\nPURCHASE"
	zoom(self, 1.1, 0.1)
	zoom(shadow, 1.05, 0.1)

func _on_button_mouse_exited() -> void:
	button.text = ""
	zoom(self, 1.0, 0.1)
	zoom(shadow, 1.0, 0.1)

func _on_button_pressed() -> void:
	if Global.coins_total >= price and !purchased:
		Global.palette1_purchased = true
		Global.coins_total -= price
		purchased = true
		match palette_index:
			1: Global.palette1_purchased = true
			2: Global.palette2_purchased = true
			3: Global.palette3_purchased = true
			4: Global.palette4_purchased = true
			5: Global.palette5_purchased = true
			6: Global.palette6_purchased = true
		visibilites()

func zoom(object, scale:float, speed:float) -> void:
	var tween = create_tween()
	tween.tween_property(object, "scale", Vector2(scale, scale), speed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func visibilites():
	button.visible = !purchased
	equip_container.visible = purchased
	sold_out.visible = purchased

func _on_equip_pressed() -> void:
	Global.equip_palette(palette_index)
	Global.change_equipped_palette.emit()
	equipped = true

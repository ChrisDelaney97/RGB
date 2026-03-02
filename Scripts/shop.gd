extends Control

@onready var coins: Label = %Coins
@onready var crt: CanvasLayer = $CRT
@onready var palette_box_1: TextureRect = %PaletteBox1
@onready var palette_box_2: TextureRect = %PaletteBox2
@onready var palette_box_3: TextureRect = %PaletteBox3
@onready var palette_box_4: TextureRect = %PaletteBox4
@onready var palette_box_5: TextureRect = %PaletteBox5
@onready var palette_box_6: TextureRect = %PaletteBox6

const outline_shader : Shader = preload("res://Art/Shaders/outline.gdshader")

func _ready() -> void:
	Global.change_equipped_palette.connect(palette_equip_shader)
	crt.show()
	palette_equip_shader()

func _process(delta: float) -> void:
	coins.text = "COINS: " + str(Global.coins_total)

func palette_equip_shader():
	var palette_boxes : Array = [palette_box_1, palette_box_2, palette_box_3, palette_box_4, palette_box_5, palette_box_6]
	for palette_box in palette_boxes:
		if palette_box.palette_index == Global.current_palette.palette_index:
			var mat = ShaderMaterial.new()
			mat.shader = outline_shader
			palette_box.material = mat
		else:
			palette_box.material = null

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Screens/main.tscn")

extends Node

signal change_equipped_palette

var rgb : int = 0
var game_running : bool = false
var game_over : bool = false
var input_enabled : bool

var coins_total : int = 100
var coins_collected : int

var primary : Color 
var secondary : Color
var tertiary : Color
var floor_art
var bg_art

var current_palette : Palette

@onready var palette_1 : Palette = preload("res://Art/80s_style/Palette_1/palette_1.tres")
@onready var palette_2 : Palette = preload("res://Art/80s_style/Palette_2/palette_2.tres")
@onready var palette_3 : Palette = preload("res://Art/80s_style/Palette_3/palette_3.tres")
@onready var palette_4 : Palette = preload("res://Art/80s_style/Palette_4/palette_4.tres")
@onready var palette_5 : Palette = preload("res://Art/80s_style/Palette_5/palette_5.tres")
@onready var palette_6 : Palette = preload("res://Art/80s_style/Palette_6/palette_6.tres")

#var palette_1 : Array = [
	#Color.from_rgba8(255, 0, 25, 255),
	#Color.from_rgba8(255, 125, 0, 255),
	#Color.from_rgba8(25, 115, 181, 255),
	#"res://Art/80sstyle/Palette_1/floor_1.png",
	#"res://Art/80sstyle/Palette_1/bg_1.png"]
#var palette_2 : Array = [
	#Color.from_rgba8(118, 0, 14, 255),
	#Color.from_rgba8(252, 114, 0, 255),
	#Color.from_rgba8(248, 218, 10, 255),
	#"res://Art/80sstyle/Palette_2/floor_2.png",
	#"res://Art/80sstyle/Palette_2/bg_2.png"]
#var palette_3 : Array = [
	#Color.from_rgba8(230, 38, 140, 255),
	#Color.from_rgba8(252, 220, 56, 255),
	#Color.from_rgba8(19, 188, 220, 255),
	#"res://Art/80sstyle/Palette_3/floor_3.png",
	#"res://Art/80sstyle/Palette_3/bg_3.png"]
#var palette_4 : Array = [
	#Color.from_rgba8(214, 85, 54, 255),
	#Color.from_rgba8(221, 214, 47, 255),
	#Color.from_rgba8(20, 164, 189, 255),
	#"res://Art/80sstyle/Palette_4/floor_4.png",
	#"res://Art/80sstyle/Palette_4/bg_4.png"]
#var palette_5 : Array = [
	#Color.from_rgba8(205, 40, 102, 255),
	#Color.from_rgba8(123, 58, 131, 255),
	#Color.from_rgba8(39, 63, 150, 255),
	#"res://Art/80sstyle/Palette_5/floor_5.png",
	#"res://Art/80sstyle/Palette_5/bg_5.png"]
#var palette_6 : Array = [
	#Color.from_rgba8(124, 43, 76, 255),
	#Color.from_rgba8(246, 182, 7, 255),
	#Color.from_rgba8(55, 154, 174, 255),
	#"res://Art/80sstyle/Palette_6/floor_6.png",
	#"res://Art/80sstyle/Palette_6/bg_6.png"]

var palette1_purchased : bool = true
var palette2_purchased : bool
var palette3_purchased : bool
var palette4_purchased : bool
var palette5_purchased : bool
var palette6_purchased : bool

func _ready() -> void:
	equip_palette(1)

func set_palette():
	primary = current_palette.primary
	secondary = current_palette.secondary
	tertiary = current_palette.tertiary
	floor_art = current_palette.floor_texture
	bg_art = current_palette.bg_texture

func equip_palette(palette_index):
	match palette_index:
		1: current_palette = palette_1
		2: current_palette = palette_2
		3: current_palette = palette_3
		4: current_palette = palette_4
		5: current_palette = palette_5
		6: current_palette = palette_6
	set_palette()

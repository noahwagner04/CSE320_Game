extends PanelContainer

signal slot_clicked(index: int, button: int)

@export var rarity_1_texture: AtlasTexture
@export var rarity_2_texture: AtlasTexture
@export var rarity_3_texture: AtlasTexture
@export var rarity_4_texture: AtlasTexture
@export var rarity_5_texture: AtlasTexture
@export var rarity_6_texture: AtlasTexture

@onready var texture_rect = $MarginContainer/TextureRect
@onready var quantity_label = $QuantityLabel
@onready var rarity_texture_rect = $MarginContainer/RarityTextureRect



func set_slot_data(slot_data: SlotData):
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	if item_data is ItemDataWeapon:
		tooltip_text = "%s\n%s\n%s" % [item_data.name, item_data.description, item_data.weapon_rarity]
		match item_data.weapon_rarity:
			1:
				rarity_texture_rect.show()
				rarity_texture_rect.texture = rarity_1_texture
			2:
				rarity_texture_rect.show()
				rarity_texture_rect.texture = rarity_2_texture
			3:
				rarity_texture_rect.show()
				rarity_texture_rect.texture = rarity_3_texture
			4:
				rarity_texture_rect.show()
				rarity_texture_rect.texture = rarity_4_texture
			5:
				rarity_texture_rect.show()
				rarity_texture_rect.texture = rarity_5_texture
			6:
				rarity_texture_rect.show()
				rarity_texture_rect.texture = rarity_6_texture
			_:
				rarity_texture_rect.hide()
			

	if slot_data.quantity > 1:
		quantity_label.text = "x%s" % slot_data.quantity
		quantity_label.show()
	else:
		quantity_label.hide()


func _on_gui_input(event):
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		slot_clicked.emit(get_index(), event.button_index)

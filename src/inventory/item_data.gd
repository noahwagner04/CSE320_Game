class_name ItemData

extends Resource

@export var name: String = ""
@export_multiline var description: String = ""
@export_enum("Weapon", "Armor", "Jewelry", "Consumable") var type: String = ""
@export var stackable: bool = false
@export var texture: AtlasTexture


extends ItemData
class_name ItemDataConsumable

@export var heal_value: int

func use(target):
	if heal_value != 0:
		target.heal(heal_value)
	pass

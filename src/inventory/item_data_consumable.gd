extends ItemData
class_name ItemDataConsumable

@export var health_recover_value: int
@export var stamina_recover_value: int

func use(target):
	if health_recover_value != 0:
		target.heal(health_recover_value)
	if stamina_recover_value != 0:
		target.energize(stamina_recover_value)


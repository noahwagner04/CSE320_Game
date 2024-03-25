extends Resource
class_name Pool

@export var rolls: int
@export_range(0, 100, 0.1, "suffix: %") var chance_to_roll: float = 0
@export var entries: Array[Entry]

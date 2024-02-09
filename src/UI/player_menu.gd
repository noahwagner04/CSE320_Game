extends CanvasLayer

@onready var health_label : RichTextLabel = $VBoxContainer/Health
@onready var defense_label : RichTextLabel = $VBoxContainer/Defense
@onready var hp_regen_label : RichTextLabel = $"VBoxContainer/HP Regen"
@onready var attack_label : RichTextLabel = $VBoxContainer/Attack
@onready var dexterity_label : RichTextLabel = $VBoxContainer/Dexterity
@onready var speed_label : RichTextLabel = $VBoxContainer/Speed
@onready var sp_regen_label : RichTextLabel = $"VBoxContainer/SP Regen"
@onready var stamina_label : RichTextLabel = $VBoxContainer/Stamina

func update_health(new_health : int):
	health_label.bbcode_text = "Health " + str(new_health)

func _ready():
	var stats = $"../PlayerStats"
	if stats != null:
		stats.connect("health_changed", update_health)
	else:
		print("Its null")
		print_tree_pretty()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

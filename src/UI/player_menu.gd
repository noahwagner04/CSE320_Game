extends CanvasLayer

var health_label : RichTextLabel
var defense_label : RichTextLabel
var hp_regen_label : RichTextLabel
var attack_label : RichTextLabel
var dexterity_label : RichTextLabel
var speed_label : RichTextLabel
var sp_regen_label : RichTextLabel
var stamina_label : RichTextLabel

# Called when the node enters the scene tree for the first time.

func load_stats_data():
	health_label = $VBoxContainer/Health
	defense_label = $VBoxContainer/Defense
	hp_regen_label = $"VBoxContainer/HP Regen"
	attack_label = $VBoxContainer/Attack
	dexterity_label = $VBoxContainer/Dexterity
	speed_label = $VBoxContainer/Speed
	sp_regen_label = $"VBoxContainer/SP Regen"
	stamina_label = $VBoxContainer/Stamina
	health_label.bbcode_text = "Health "
	defense_label.bbcode_text = "Defense "
	hp_regen_label.bbcode_text = "HP Regeneration "
	attack_label.bbcode_text = "Attack "
	dexterity_label.bbcode_text = "Dexterity "
	speed_label.bbcode_text = "Speed "
	sp_regen_label.bbcode_text = "SP Regeneration "
	stamina_label.bbcode_text = "Stamina "

func update_health(new_health : int):
	health_label = $VBoxContainer/Health
	health_label.bbcode_text = "Health " + str(new_health)

func _ready():
	load_stats_data()
	var stats = get_node("/root/Player/PlayerStats")
	if stats != null:
		stats.connect("health_changed", update_health)
	else:
		print("Its null")
		print_tree_pretty()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

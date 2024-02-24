extends CanvasLayer

@onready var health_label : RichTextLabel = $Panel/VBoxContainer/Health
@onready var defense_label : RichTextLabel = $Panel/VBoxContainer/Defense
@onready var hp_regen_label : RichTextLabel = $"Panel/VBoxContainer/HP Regen"
@onready var attack_label : RichTextLabel = $Panel/VBoxContainer/Attack
@onready var dexterity_label : RichTextLabel = $Panel/VBoxContainer/Dexterity
@onready var speed_label : RichTextLabel = $Panel/VBoxContainer/Speed
@onready var sp_regen_label : RichTextLabel = $"Panel/VBoxContainer/SP Regen"
@onready var stamina_label : RichTextLabel = $Panel/VBoxContainer/Stamina
@onready var panel = $Panel

func _ready():
	var stats = $"../PlayerStats"
	render_stats()
	stats.connect("player_leveled_up", render_stats)
	$"..".toggle_inventory.connect(toggle_player_menu)

func toggle_player_menu():
	panel.visible = not panel.visible

func render_stats():
	var stats = $"../PlayerStats"
	health_label.bbcode_text = "Health " + str(stats.health)
	defense_label.bbcode_text = "Defense " + str(stats.defense) + " (" + ("+" if stats.defense_mod >= 0 else "") + str(stats.defense_mod) + ")" 
	hp_regen_label.bbcode_text = "HP Regen " + str(stats.hp_regen) + " (" + ("+" if stats.hp_regen_mod >= 0 else "") + str(stats.hp_regen_mod) + ")" 
	attack_label.bbcode_text = "Attack " + str(stats.attack) + " (" + ("+" if stats.attack_mod >= 0 else "") + str(stats.attack_mod) + ")" 
	dexterity_label.bbcode_text = "Dexterity " + str(stats.dexterity) + " (" + ("+" if stats.dexterity_mod >= 0 else "") + str(stats.dexterity_mod) + ")" 
	speed_label.bbcode_text = "Speed " + str(stats.speed) + " (" + ("+" if stats.speed_mod >= 0 else "") + str(stats.speed_mod) + ")" 
	sp_regen_label.bbcode_text = "SP Regen " + str(stats.sp_regen) + " (" + ("+" if stats.sp_regen_mod >= 0 else "") + str(stats.sp_regen_mod) + ")" 
	stamina_label.bbcode_text = "Stamina " + str(stats.stamina) + " (" + ("+" if stats.stamina_mod >= 0 else "") + str(stats.stamina_mod) + ")" 
	

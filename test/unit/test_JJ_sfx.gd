extends GutTest

#Acceptance test
func test_vole_hurt():
	var volescene = preload("res://src/enemies/giant_vole.tscn").instantiate()
	add_child_autofree(volescene)
	
	var hithurt = preload("res://test/scenes/hit_hurt_box_test.tscn").instantiate()
	add_child_autofree(hithurt)
	var children = hithurt.get_children()
	var hit_box = (children.filter(func(obj): return obj is HitBox))[0]
	
	volescene._on_hurt_box_hurt(hit_box)
	assert_true(volescene.hurtsound_played, "volehurt must play audio when Giant_Vole receives damage")

#Acceptance test
func test_vole_death():
	var volescene = preload("res://src/enemies/giant_vole.tscn").instantiate()
	add_child_autofree(volescene)
	
	volescene._on_health_container_health_depleted()
	assert_true(volescene.deathsound_played, "voledeath must play audio when Voles die")

#Acceptance test
func test_bug_hurt():
	var bugscene = preload("res://src/enemies/giant_dragonfly.tscn").instantiate()
	add_child_autofree(bugscene)
	
	var hithurt = preload("res://test/scenes/hit_hurt_box_test.tscn").instantiate()
	add_child_autofree(hithurt)
	var children = hithurt.get_children()
	var hit_box = (children.filter(func(obj): return obj is HitBox))[0]
	
	bugscene._on_hurt_box_hurt(hit_box)
	assert_true(bugscene.hurtsound_played, "bughurt must play audio when Bugs take damage")

#Acceptance test
func test_bug_death():
	var bugscene = preload("res://src/enemies/giant_dragonfly.tscn").instantiate()
	add_child_autofree(bugscene)
	
	bugscene._on_health_container_health_depleted()
	assert_true(bugscene.deathsound_played, "bughurt must play audio when Bugs take damage")

#Acceptance test
func test_player_hurt():
	var playerscene = preload("res://src/player/player.tscn").instantiate()
	add_child_autofree(playerscene)
	
	playerscene._on_health_container_health_changed(-.1)
	assert_true(playerscene.hurtsound_played, "playerhurt must play audio when Player takes damage")

#Acceptance test
func test_player_death():
	var playerscene = preload("res://src/player/player.tscn").instantiate()
	add_child_autofree(playerscene)
	
	playerscene._on_health_container_health_depleted()
	assert_true(playerscene.deathsound_played, "playerdeath must play audio when Player dies")

#Accept test
func test_bearvole_hurt():
	var bearvolescene = preload("res://src/enemies/boss_behemoth_vole.tscn").instantiate()
	add_child_autofree(bearvolescene)
	
	var hithurt = preload("res://test/scenes/hit_hurt_box_test.tscn").instantiate()
	add_child_autofree(hithurt)
	var children = hithurt.get_children()
	var hit_box = (children.filter(func(obj): return obj is HitBox))[0]
	
	bearvolescene._on_hurt_box_hurt(hit_box)
	assert_true(bearvolescene.hurtsound_played, "bearvolehurt must play audio when bearvole takes damage")

#Acceptance test
func test_bearvole_death():
	var bearvolescene = preload("res://src/enemies/boss_behemoth_vole.tscn").instantiate()
	add_child_autofree(bearvolescene)
	
	var hithurt = preload("res://test/scenes/hit_hurt_box_test.tscn").instantiate()
	add_child_autofree(hithurt)
	var children = hithurt.get_children()
	var hit_box = (children.filter(func(obj): return obj is HitBox))[0]
	
	bearvolescene._on_health_container_health_depleted()
	assert_true(bearvolescene.deathsound_played, "bearvoledeath must play audio when bearvole health depleted")

#Acceptance test
func test_bearvole_summon():
	var bearvolescene = preload("res://src/enemies/boss_behemoth_vole.tscn").instantiate()
	add_child_autofree(bearvolescene)
	
	bearvolescene.summon_voles(1)
	assert_true(bearvolescene.deathsound_played, "bearvolesummon must play audio when bearvole summons ads")

#Acceptance test
func test_bearvole_shot():
	var bearvolescene = preload("res://src/enemies/boss_behemoth_vole.tscn").instantiate()
	add_child_autofree(bearvolescene)
	
	bearvolescene.spit_vomit()
	assert_true(bearvolescene.deathsound_played, "bearvoleshot must play audio when bearvole summons ads")

#Acceptance test
func test_swallow_hurt():
	var swallowscene = preload("res://src/enemies/swallowed_man.tscn").instantiate()
	add_child_autofree(swallowscene)
	
	var hithurt = preload("res://test/scenes/hit_hurt_box_test.tscn").instantiate()
	add_child_autofree(hithurt)
	var children = hithurt.get_children()
	var hit_box = (children.filter(func(obj): return obj is HitBox))[0]
	
	swallowscene._on_hurt_box_hurt(hit_box)
	assert_true(swallowscene.hurtsound_played, "swallow must play hurtsound when losing health")

#Acceptance test
func test_swallow_death():
	var swallowscene = preload("res://src/enemies/swallowed_man.tscn").instantiate()
	add_child_autofree(swallowscene)
	
	swallowscene._on_health_container_health_depleted()
	assert_true(swallowscene.hurtsound_played, "swallow must play deathsound when dying")

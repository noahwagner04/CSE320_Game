extends Area2D

signal collision_object_entered(object: CollisionObject2D)
signal collision_object_exited(object: CollisionObject2D)

@export var detect_area := true
@export var detect_character_body := false
@export var detect_rigidbody := false
@export var detect_static := false

var filter_func := func(_col_obj: CollisionObject2D): return true
var intersecting_colliders: Array[Node2D] = []


func get_closest_collider() -> CollisionObject2D:
	var closest_col: CollisionObject2D = null
	var closest_dist: float = INF
	for col in intersecting_colliders:
		var sq_dist := global_position.distance_squared_to(col.global_position)
		if sq_dist < closest_dist:
			closest_dist = sq_dist
			closest_col = col
	return closest_col


func add_collision_object(collision_object: CollisionObject2D):
	intersecting_colliders.append(collision_object)
	intersecting_colliders = intersecting_colliders.filter(filter_func)
	emit_signal("collision_object_entered", collision_object)


func remove_collision_object(collision_object: CollisionObject2D):
	if not (collision_object in intersecting_colliders):
		return
	intersecting_colliders.erase(collision_object)
	emit_signal("collision_object_exited", collision_object)


func _on_area_entered(area):
	if detect_area:
		add_collision_object(area)


func _on_area_exited(area):
	if detect_area:
		remove_collision_object(area)


func _on_body_entered(body):
	if body is CharacterBody2D and detect_character_body:
		add_collision_object(body)
	elif body is RigidBody2D and detect_rigidbody:
		add_collision_object(body)
	elif body is StaticBody2D and detect_static:
		add_collision_object(body)


func _on_body_exited(body):
	if body is CharacterBody2D and detect_character_body:
		remove_collision_object(body)
	elif body is RigidBody2D and detect_rigidbody:
		remove_collision_object(body)
	elif body is StaticBody2D and detect_static:
		remove_collision_object(body)

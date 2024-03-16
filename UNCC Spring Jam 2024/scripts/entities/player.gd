extends Area2D
class_name Player

signal new_turn(enemy_turn)

@onready var ray = $PhysicsRay

var attack_scene = preload("res://scenes/attacks/projectile_attack.tscn")

var tile_size = 8
var animation_speed = 6
var moving = false
var enemy_turn = false

var has_attack := true
var last_move = Vector2.RIGHT

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

func movement_tween(dir):
	var tween = create_tween()
	tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
	enemy_turn = !enemy_turn
	last_move = inputs[dir]
	emit_signal("new_turn", enemy_turn)
	moving = true
	await tween.finished
	moving = false

func _physics_process(delta):
	for dir in inputs.keys():
		if Input.is_action_pressed(dir) and moving == false:
			move(dir)

func _unhandled_input(event):
	if event.is_action_pressed("attack") and moving == false:
		create_attack()

func move(dir):
	ray.target_position = inputs[dir] * tile_size
	
	ray.force_raycast_update()
	if !ray.is_colliding():
		movement_tween(dir)
	elif ray.get_collider() is TileMap:
		pass
	elif ray.get_collider() is Entity:
		if ray.get_collider().push(dir) == true:
			movement_tween(dir)

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func kill():
	call_deferred("queue_free")

func _on_vision_cone_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var cell_pos = body.get_coords_for_body_rid(body_rid)
		body.set_cell(0, cell_pos, 0, Vector2(2, 5))

func _on_vision_cone_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	pass#if body is TileMap:
		#var cell_pos = body.get_coords_for_body_rid(body_rid)
		#body.set_cell(0, cell_pos, 0, Vector2(1, 6))

func _on_vision_cone_area_entered(area):
	if area is Entity:
		area.change_visibility()
		
		if area is Enemy:
			area.sleep = false

func _on_area_entered(area):
	if area is Pickup:
		area.collect()
	
	if area is Attack:
		print("hit")

func create_attack():
	var attack = attack_scene.instantiate()
	get_tree().get_root().add_child(attack)
	attack.player_info(self, last_move)
	attack.global_position = global_position + last_move * tile_size

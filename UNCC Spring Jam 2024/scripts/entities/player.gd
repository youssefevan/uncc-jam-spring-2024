extends Area2D
class_name Player

signal new_turn(enemy_turn)
signal got_key

@onready var ray = $PhysicsRay

var attack_scene = preload("res://scenes/attacks/projectile_attack.tscn")

var tile_size = 8
var animation_speed = 6
var moving = false
var enemy_turn = false

var has_attack : bool
var last_move = Vector2.RIGHT
var has_key := false

var max_health = 4
var health
var coins
var dead := false

var prev_sprite_frame

func _ready():
	dead = false
	$CanvasLayer/Control/Dead.visible = false
	health = Global.player_health
	coins = Global.player_coins
	has_attack = Global.player_has_attack
	has_key = false
	$CanvasLayer/Control/HealthText.text = str(health)
	$CanvasLayer/Control/CoinsText.text = str(coins)
	if has_attack:
		$Sprite.frame = 54
	else:
		$Sprite.frame = 36

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
		if Input.is_action_pressed(dir) and moving == false and dead == false:
			if $Sprite.frame == 52 and prev_sprite_frame:
				$Sprite.frame = prev_sprite_frame
			move(dir)

func _unhandled_input(event):
	if event.is_action_pressed("attack") and moving == false and has_attack == true:
		create_attack()

func move(dir):
	ray.target_position = inputs[dir] * tile_size
	
	ray.force_raycast_update()
	if !ray.is_colliding():
		movement_tween(dir)
	elif ray.get_collider() is TileMap:# or ray.get_collider() is Enemy:
		pass

#func _process(delta):
	#if Input.is_action_just_pressed("restart"):
		#get_tree().reload_current_scene()

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
		if area is Knife:
			if has_attack == false:
				has_attack = true
				$Sprite.frame = 54
				area.collect()
				$Knife.play()
		elif area is Key:
			has_key = true
			emit_signal("got_key")
			area.collect()
			$Key.play()
		elif area is Potion:
			if health < max_health:
				health += 1
				$CanvasLayer/Control/HealthText.text = str(health)
				area.collect()
				$OneUp.play()
		elif area is Coin:
			coins += 1
			$CanvasLayer/Control/CoinsText.text = str(coins)
			area.collect()
			$Coin.play()
		else:
			area.collect()
	
	elif area is Attack:
		get_hit()
	
	if area is Exit:
		if area.locked == false:
			next_level()

func next_level():
	Global.player_health = health
	Global.player_coins = coins
	Global.player_has_attack = has_attack
	if Global.level < 12:
		get_tree().change_scene_to_file("res://scenes/level_transition.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/win_screen.tscn")

func create_attack():
	has_attack = false
	$Sprite.frame = 36
	
	$Attack.play()
	
	var attack = attack_scene.instantiate()
	get_parent().add_child(attack)
	attack.player_info(self, last_move)
	attack.global_position = global_position + last_move * tile_size

func get_hit():
	health -= 1
	$CanvasLayer/Control/HealthText.text = str(health)
	if health == 0:
		die()
	else:
		$GetHurt.play()
		prev_sprite_frame = $Sprite.frame
		$Sprite.frame = 52
		

func die():
	dead = true
	$Sprite.frame = 52
	
	$Death.play()
	
	Global.player_health = 4
	Global.player_has_attack = false
	Global.player_coins = 0
	Global.level = 0
	
	await get_tree().create_timer(0.3).timeout
	$CanvasLayer/Control/Dead.visible = true
	await get_tree().create_timer(0.3).timeout
	$CanvasLayer/Control/Dead.visible = false
	await get_tree().create_timer(0.3).timeout
	$CanvasLayer/Control/Dead.visible = true
	await get_tree().create_timer(0.3).timeout
	$CanvasLayer/Control/Dead.visible = false
	await get_tree().create_timer(0.3).timeout
	$CanvasLayer/Control/Dead.visible = true
	await get_tree().create_timer(0.3).timeout
	$CanvasLayer/Control/Dead.visible = false
	await get_tree().create_timer(0.3).timeout
	$CanvasLayer/Control/Dead.visible = true
	await get_tree().create_timer(0.3).timeout
	$CanvasLayer/Control/Dead.visible = false
	await get_tree().create_timer(0.3).timeout
	$CanvasLayer/Control/Dead.visible = true
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

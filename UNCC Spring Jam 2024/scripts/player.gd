extends Entity

@onready var ray = $PhysicsRay

func _ready():
	pass

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir) and moving == false:
			move(dir)

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

func _on_area_entered(area):
	pass

func kill():
	call_deferred("queue_free")


func _on_vision_cone_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var cell_pos = body.get_coords_for_body_rid(body_rid)
		body.set_cell(0, cell_pos, 0, Vector2(2, 5))

func _on_vision_cone_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var cell_pos = body.get_coords_for_body_rid(body_rid)
		body.set_cell(0, cell_pos, 0, Vector2(1, 6))

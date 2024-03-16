extends Entity
class_name Enemy

var melee_attack_scene = preload("res://scenes/attacks/melee_attack.tscn")

var grid_size = 8
var animation_speed = 6

var astar_grid

var player
var tile_map

var setup = false
var sleep = true
var take_turn = false

var path

var player_in_range

func _ready():
	super._ready()
	player = get_tree().get_first_node_in_group("Player")
	player.new_turn.connect(new_turn)

func movement_tween(pos):
	var tween = create_tween()
	tween.tween_property(self, "position", pos, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)

func setup_grid(tiles):
	astar_grid = AStarGrid2D.new()
	tile_map = tiles
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2i(grid_size, grid_size)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	var region_size = astar_grid.region.size
	var region_position = astar_grid.region.position
	
	for x in region_size.x:
		for y in region_size.y:
			var tile_position = Vector2i(x + region_position.x, y + region_position.y)
			
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			
			if tile_data != null:
				astar_grid.set_point_solid(tile_position)
	
	setup = true

func move():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var occupied_positions = []
	
	for i in enemies:
		if i == self:
			continue
		
		occupied_positions.append(tile_map.local_to_map(i.global_position))
		if i.path and not i.path.is_empty():
			occupied_positions.append(i.path[0])
	
	for i in occupied_positions:
		astar_grid.set_point_solid(i)
	
	path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	
	for i in occupied_positions:
		astar_grid.set_point_solid(i, false)
	
	path.pop_front()
	
	if player_in_range and sleep == false:
		attack()
	elif path.size() > 0:
		if take_turn and sleep == false:
			movement_tween(tile_map.map_to_local(path[0]))

func new_turn(enemy_turn):
	take_turn = enemy_turn
	if setup == true and sleep == false:
		move()

func attack():
	if setup == true and sleep == false:
		var attack = melee_attack_scene.instantiate()
		add_child(attack)
		attack.global_position = player.global_position


func _on_player_detection_area_entered(area):
	if area is Player:
		player_in_range = true

func _on_player_detection_area_exited(area):
	if area is Player:
		player_in_range = false

func _on_area_entered(area):
	if area is Attack:
		call_deferred('free')

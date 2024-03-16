extends Entity
class_name Enemy

var grid_size = 8
var animation_speed = 6

var astar_grid

var player
var tile_map

var setup = false
var sleep = true

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
	
	for i in occupied_positions:
		astar_grid.set_point_solid(i)
	
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	
	for i in occupied_positions:
		astar_grid.set_point_solid(i, false)
	
	path.pop_front()
	
	if path.size() > 0:
		movement_tween(tile_map.map_to_local(path[0]))

func new_turn():
	if setup == true and sleep == false:
		move()

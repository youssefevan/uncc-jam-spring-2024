extends Node2D

const player_scence = preload("res://scenes/entities/player.tscn")
const exit_scene = preload("res://scenes/entities/exit.tscn")
const key_scene = preload("res://scenes/entities/pickups/key.tscn")
const potion_scene = preload("res://scenes/entities/pickups/potion.tscn")
const coin_scene = preload("res://scenes/entities/pickups/coin.tscn")
const knife_scene = preload("res://scenes/entities/pickups/knife.tscn")
const enemy_scene = preload("res://scenes/entities/enemy.tscn")

const grid_size = 8

var borders = Rect2(4, 4, 24, 24)

@onready var tile_map = $TileMap

func _ready():
	randomize()
	generate_level()

func generate_level():
	var walker_starting_position = Vector2(16, 16)
	var walker_steps = 400
	# create new walker, get map, delete walker
	var walker = Walker.new(walker_starting_position, borders)
	var map = walker.walk(walker_steps)
	walker.queue_free()
	
	tile_map.set_cells_terrain_connect(0, map, 0, -1)
	
	# store used position
	var used_positions = []
	
	# spawn player at first step
	var player = player_scence.instantiate()
	add_child(player)
	player.position = map.front() * grid_size
	used_positions.append(player.position)
	
	# spawn exit at last step
	var exit = exit_scene.instantiate()
	add_child(exit)
	exit.position = walker.get_end_room().position * grid_size
	used_positions.append(exit.position)
	
	# spawn key
	var key = key_scene.instantiate()
	add_child(key)
	key.position = map[ceil(walker_steps/2)] * grid_size
	used_positions.append(key.position)
	
	# spawn potion
	var potion = potion_scene.instantiate()
	add_child(potion)
	potion.position = map[ceil(walker_steps/3)] * grid_size
	used_positions.append(potion.position)
	
	# spawn coin
	for room in walker.rooms:
		if room["size"].x == 2 and room["size"].y <= 3 and room["position"] * grid_size not in used_positions:
			var coin = coin_scene.instantiate()
			add_child(coin)
			coin.position = room["position"] * grid_size
			used_positions.append(coin.position)
	
	# spawn knife
	for room in walker.rooms:
		if room["size"].x <= 3 and room["size"].y <= 3 and room["position"] * grid_size not in used_positions:
			var knife = knife_scene.instantiate()
			add_child(knife)
			knife.position = room["position"] * grid_size
			used_positions.append(knife.position)
	
	# spawn enemy
	for room in walker.rooms:
		if room["size"].x == 4 or room["size"].x == 4:
			if room["position"] * grid_size not in used_positions:
				var enemy = enemy_scene.instantiate()
				add_child(enemy)
				enemy.position = room["position"] * grid_size
				enemy.setup_grid(tile_map)
				used_positions.append(enemy.position)

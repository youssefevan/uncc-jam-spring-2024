extends Node2D

const player_scence = preload("res://scenes/entities/player.tscn")
const exit_scene = preload("res://scenes/entities/exit.tscn")
const key_scene = preload("res://scenes/entities/pickups/key.tscn")
const potion_scene = preload("res://scenes/entities/pickups/potion.tscn")
const coin_scene = preload("res://scenes/entities/pickups/coin.tscn")

const grid_size = 8

var borders = Rect2(2, 2, 26, 26)

@onready var tile_map = $TileMap

func _ready():
	randomize()
	generate_level()

func generate_level():
	var walker_starting_position = Vector2(15, 15)
	var walker_steps = 512
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
		if room["size"].x == 2 and room["position"] * grid_size not in used_positions:
			var coin = coin_scene.instantiate()
			add_child(coin)
			coin.position = room["position"] * grid_size
			used_positions.append(coin.position)

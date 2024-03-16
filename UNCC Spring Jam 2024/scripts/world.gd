extends Node2D

const player_scence = preload("res://scenes/player.tscn")
const exit_scene = preload("res://scenes/exit.tscn")

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
	
	# spawn player at first step
	var player = player_scence.instantiate()
	add_child(player)
	player.position = map.front() * grid_size
	
	# spawn exit at last step
	var exit = exit_scene.instantiate()
	add_child(exit)
	exit.position = walker.get_end_room().position * grid_size
	
	tile_map.set_cells_terrain_connect(0, map, 0, -1)

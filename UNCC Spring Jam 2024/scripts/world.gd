extends Node2D

var borders = Rect2(2, 2, 26, 26)

@onready var tile_map = $TileMap

func _ready():
	generate_level()

func generate_level():
	var walker_starting_position = Vector2(13, 13)
	var walker_steps = 512
	# create new walker, get map, delete walker
	var walker = Walker.new(walker_starting_position, borders)
	var map = walker.walk(walker_steps)
	walker.queue_free()
	
	tile_map.set_cells_terrain_connect(0, map, 0, -1)

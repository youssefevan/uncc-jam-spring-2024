extends Node
class_name Walker

const DIRECTIONS = [
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.LEFT,
	Vector2.DOWN
]

const turn_chance = 0.25
const max_steps_since_turn = 16

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var steps_since_turn = 0

func _init(starting_position, new_borders):
	# make sure starting position is inside of border
	assert(new_borders.has_point(starting_position))
	
	# initialize position
	position = starting_position
	step_history.append(position)
	
	# initialize borders
	borders = new_borders
	

func walk(steps):
	for step in steps:
		if randf() <= turn_chance or steps_since_turn >= max_steps_since_turn:
			change_direction()
		
		if step():
			step_history.append(position)
		else:
			change_direction()
	
	return step_history

func step():
	var target_position = position + direction
	
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		# step in current direction would be outside of the borders
		return false

func change_direction():
	steps_since_turn = 0
	
	var directions = DIRECTIONS.duplicate()
	
	# remove current direction from list of possible directions so it doesn't pick current direction
	directions.erase(direction)
	# shuffle list of directions
	directions.shuffle()
	# set direction to first element in shuffled directions list
	direction = directions.pop_front() 
	
	while not borders.has_point(position + direction):
		# pick next direction in list if top result is outside of the borders
		direction = directions.pop_front()
	
extends Entity
class_name Exit

var locked := true

var player

func _ready():
	super._ready()
	locked = true
	$Sprite.frame = 45
	player = get_tree().get_first_node_in_group("Player")
	player.got_key.connect(got_key)

func got_key():
	locked = false
	$Sprite.frame = 46

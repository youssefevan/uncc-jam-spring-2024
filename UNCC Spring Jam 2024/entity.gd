extends Area2D
class_name Entity

@onready var sprite = $Sprite

func _ready():
	sprite.visible = false

func change_visibility():
	sprite.visible = true

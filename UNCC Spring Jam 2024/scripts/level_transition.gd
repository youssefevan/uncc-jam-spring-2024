extends Control

func _ready():
	Global.level += 1
	
	for i in $Pyramid.get_children():
		i.visible = false
	
	animate()

func animate():
	for i in range(0, Global.level):
		$Pyramid.get_children()[i].visible = true
	
	$Pyramid.get_children()[Global.level-1].visible = true
	await get_tree().create_timer(0.3).timeout
	$Pyramid.get_children()[Global.level-1].visible = false
	await get_tree().create_timer(0.3).timeout
	$Pyramid.get_children()[Global.level-1].visible = true
	await get_tree().create_timer(0.3).timeout
	$Pyramid.get_children()[Global.level-1].visible = false
	await get_tree().create_timer(0.3).timeout
	$Pyramid.get_children()[Global.level-1].visible = true
	await get_tree().create_timer(0.3).timeout
	$Pyramid.get_children()[Global.level-1].visible = false
	await get_tree().create_timer(0.3).timeout
	$Pyramid.get_children()[Global.level-1].visible = true
	await get_tree().create_timer(0.3).timeout
	$Pyramid.get_children()[Global.level-1].visible = false
	await get_tree().create_timer(0.3).timeout
	$Pyramid.get_children()[Global.level-1].visible = true
	await get_tree().create_timer(2).timeout
	
	get_tree().change_scene_to_file("res://scenes/world.tscn")

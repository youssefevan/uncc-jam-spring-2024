extends Node2D

func _ready():
	$Control/CoinsText.text = str(Global.player_coins)
	flash()

func flash():
	$Pyramid/Level12.visible = true
	await get_tree().create_timer(0.3).timeout
	$Pyramid/Level12.visible = false
	await get_tree().create_timer(0.3).timeout
	$Pyramid/Level12.visible = true
	await get_tree().create_timer(0.3).timeout
	$Pyramid/Level12.visible = false
	await get_tree().create_timer(0.3).timeout
	$Pyramid/Level12.visible = true
	await get_tree().create_timer(0.3).timeout
	$Pyramid/Level12.visible = false
	await get_tree().create_timer(0.3).timeout
	$Pyramid/Level12.visible = true
	await get_tree().create_timer(0.3).timeout
	$Pyramid/Level12.visible = false
	await get_tree().create_timer(0.3).timeout
	$Pyramid/Level12.visible = true
	#await get_tree().create_timer(0.3).timeout


func _on_home_pressed():
	Global.player_health = 4
	Global.player_has_attack = false
	Global.player_coins = 0
	Global.level = 0
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

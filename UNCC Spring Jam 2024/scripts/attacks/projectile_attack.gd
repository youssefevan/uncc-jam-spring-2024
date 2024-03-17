extends Attack

var animation_speed = 6
var dir
var player

func _ready():
	$Animator.play("rotate")

func movement_tween():
	var tween = create_tween()
	tween.tween_property(self, "position", position + dir * 8, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)

func _on_body_entered(body):
	if body is TileMap:
		hit()

func _on_area_entered(area):
	if area is Enemy:
		area.die()
		hit()

func hit():
	$Animator.play("hit")
	$SFX.play()
	dir = Vector2.ZERO

func _on_animator_animation_finished(anim_name):
	if anim_name == "hit":
		call_deferred("free")

func player_info(p, d):
	player = p
	dir = d
	player.new_turn.connect(new_turn)

func new_turn(enemy_turn):
	movement_tween()

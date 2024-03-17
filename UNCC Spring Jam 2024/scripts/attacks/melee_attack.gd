extends Attack

func _ready():
	$Animator.play("rotate")
	$SFX.play()

func _on_animator_animation_finished(anim_name):
	call_deferred("free")

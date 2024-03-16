extends Entity
class_name Pickup

func collect():
	print('collected')
	call_deferred("free")

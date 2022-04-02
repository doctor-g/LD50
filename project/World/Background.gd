extends Spatial

export var rotation_speed := 0.15

func _physics_process(delta):
	rotate(Vector3.UP, rotation_speed * delta)

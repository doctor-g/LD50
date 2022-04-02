extends KinematicBody

signal explosion_triggered

export var direction := Vector3(0,0,1)

export var speed := 1

func _physics_process(delta):
	# warning-ignore:return_value_discarded
	move_and_collide(direction*speed*delta)


func explode():
	emit_signal("explosion_triggered")
	queue_free()

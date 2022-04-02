extends KinematicBody

signal explosion_triggered

export var direction := Vector3(0,0,1)

export var speed := 1

## Base number of points this obstacle is worth when exploded
export var points := 100

func _physics_process(delta):
	# warning-ignore:return_value_discarded
	move_and_collide(direction*speed*delta)


func explode():
	emit_signal("explosion_triggered")
	queue_free()


func _on_VisibilityNotifier_screen_exited():
	queue_free()


func _on_BombDetectionArea_body_entered(body):
	# If we hit something on this layer, it must be a bomb, so kill it.
	body.kill()

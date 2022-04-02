extends KinematicBody

func _physics_process(_delta):
	var direction2d := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_down", "move_up"))
	var direction3d := Vector3(direction2d.x, 0, -direction2d.y)
	var velocity := direction3d * 20
	# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector3.UP)

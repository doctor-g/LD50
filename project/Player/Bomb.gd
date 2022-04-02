extends KinematicBody

func _physics_process(_delta):
	var direction2d := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_down", "move_up"))
	var direction3d := Vector3(direction2d.x, 0, -direction2d.y)
	var velocity := direction3d * 20
	# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector3.UP)
	
	# If we run into anything that is not a StaticBody (not a wall), then die.
	for i in get_slide_count():
		var collision := get_slide_collision(i)
		if not collision.collider is StaticBody:
			_die()


func _die():
	$Box.material.albedo_color=Color.black

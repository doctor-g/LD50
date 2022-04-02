extends KinematicBody

signal died
signal death_animation_completed
signal explosion_triggered

enum _State {
	ACTIVE,
	EXPLODED,
	DEAD
}

var _state = _State.ACTIVE

onready var _animation_player := $AnimationPlayer

func _ready():
	# Because the current animation fiddles with the material, we have to
	# reset the properties when a new bomb is created.
	# This may be unnecessary later if something besides material value tweening
	# is used for animations.
	_animation_player.play("RESET")


func _physics_process(_delta):
	if _state != _State.ACTIVE:
		return
	
	if Input.is_action_just_pressed("explode"):
		_state = _State.EXPLODED
		emit_signal("explosion_triggered")
		queue_free()
	else:
		_process_movement()


func _process_movement()->void:
	var direction2d := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_down", "move_up"))
	var direction3d := Vector3(direction2d.x, 0, -direction2d.y)
	var velocity := direction3d * 20
	# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector3.UP)


func kill():
	# You can only kill bombs that are active.
	if _state == _State.ACTIVE:
		$Box.material.albedo_color=Color.black
		_state = _State.DEAD
		emit_signal("died")
		_animation_player.play("die")


func _on_AnimationPlayer_animation_finished(anim_name:String):
	if anim_name == "die":
		emit_signal("death_animation_completed")

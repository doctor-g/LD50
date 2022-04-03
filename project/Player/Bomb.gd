extends KinematicBody

signal died
signal death_animation_completed
signal explosion_triggered

enum _State {
	SPAWNING,
	INVINCIBLE,
	ACTIVE,
	EXPLODED,
	DEAD
}

const TORUS_ROTATION_AXES = [Vector3.FORWARD, Vector3.RIGHT]
const TORUS_ROTATION_SPEEDS = [3,1.66]

export var speed := 10.0
export var spawn_origin_offset := Vector3(0,50,20)

var _state

onready var _tween := $Tween
onready var _invincibility_timer := $InvincibilityTimer
onready var _dead_timer := $DeadTimer
onready var _torii = [$CSGTorus, $CSGTorus2]

func _ready():
	_set_state(_State.SPAWNING)
	
	var target_location := transform.origin
	translate(target_location + spawn_origin_offset)
	_tween.interpolate_property(self, "translation", 
		target_location + spawn_origin_offset,
		target_location,
		1.0,
		Tween.TRANS_CUBIC, 
		Tween.EASE_OUT
	)
	_tween.start()
	# warning-ignore:return_value_discarded
	_tween.connect("tween_completed", self, "_on_spawn_tween_completed", [], CONNECT_ONESHOT)


func _on_spawn_tween_completed(_object, _key)->void:
	_set_state(_State.INVINCIBLE)


func _set_state(new_state:int)->void:
	_state = new_state
	
	match new_state:
		_State.SPAWNING:
			_change_color(Color.orange)
			
		_State.INVINCIBLE:
			_invincibility_timer.start()
			
		_State.ACTIVE:
			_change_color(Color.aliceblue)
			
		_State.DEAD:
			_change_color(Color.black)


func _change_color(color:Color)->void:
	var material := SpatialMaterial.new()
	material.albedo_color = color
	for torus in _torii:
		torus.material_override = material


func _physics_process(delta):
	for i in _torii.size():
		_torii[i].rotate(TORUS_ROTATION_AXES[i], TORUS_ROTATION_SPEEDS[i] * delta)
	
	if _state == _State.ACTIVE:
		if Input.is_action_just_pressed("explode"):
			_state = _State.EXPLODED
			emit_signal("explosion_triggered")
			queue_free()
			
	if _state == _State.ACTIVE or _state == _State.INVINCIBLE:
		_process_movement()


func _process_movement()->void:
	var direction2d := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_down", "move_up"))
	var direction3d := Vector3(direction2d.x, 0, -direction2d.y)
	var velocity := direction3d * speed
	# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector3.UP)


func kill():
	# You can only kill bombs that are active.
	if _state == _State.ACTIVE:
		$DeathSound.play()
		_set_state(_State.DEAD)
		emit_signal("died")
		_dead_timer.start()


func _on_InvincibilityTimer_timeout():
	_set_state(_State.ACTIVE)


func _on_DeadTimer_timeout():
	emit_signal("death_animation_completed")

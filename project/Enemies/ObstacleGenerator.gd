extends Spatial

signal generated(group)

const _Obstacle := preload("res://Enemies/Obstacle.tscn")
const _Group := preload("res://Enemies/ObstacleGroup.tscn")
const _BASE_SPEED := 0.3

export var radius := 20
export var initial_wait_time := 1.75
export var min_wait_time := 0.7
export var time_to_min_wait := 120.0
export var min_speed := 0.3
export var max_speed := 0.8
export var time_to_max_speed := 90.0

onready var _timer := $Timer

func _ready():
	# Spawn a group right away, then start the timer
	call_deferred("_spawn_group")
	_timer.start(initial_wait_time)


func _on_Timer_timeout():
	_spawn_group()
	var delay = lerp(initial_wait_time, min_wait_time, max(1.0, Player.seconds / time_to_min_wait))
	_timer.start(delay)


func _spawn_group()->void:
	var group : Spatial = _Group.instance()
	var theta := rand_range(0, TAU)
	var pos2d := Vector2(1,0).rotated(theta) * radius
	group.translation = Vector3(pos2d.x, 0, pos2d.y)
	group.rotate(Vector3.UP, -theta)
	group.direction = Vector3(-pos2d.x, 0, -pos2d.y)
	group.speed = _compute_current_speed()
	
	emit_signal("generated", group)


func _compute_current_speed():
	return lerp(min_speed, max_speed, min(1.0, Player.seconds/ time_to_max_speed))


func stop()->void:
	_timer.stop()

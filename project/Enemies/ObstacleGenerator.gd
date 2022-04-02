extends Spatial

signal generated(group)

const _Obstacle := preload("res://Enemies/Obstacle.tscn")
const _Group := preload("res://Enemies/ObstacleGroup.tscn")

export var radius := 20

# Current speed for created obstacles
var _speed := 0.3

onready var _timer := $Timer

func _ready():
	# Spawn a group right away, then start the timer
	call_deferred("_spawn_group")
	_timer.start()


func _on_Timer_timeout():
	_spawn_group()


func _spawn_group()->void:
	var group : Spatial = _Group.instance()
	var theta := rand_range(0, TAU)
	var pos2d := Vector2(1,0).rotated(theta) * radius
	group.translation = Vector3(pos2d.x, 0, pos2d.y)
	group.rotate(Vector3.UP, -theta)
	group.direction = Vector3(-pos2d.x, 0, -pos2d.y)
	group.speed = _speed
	
	emit_signal("generated", group)


func stop()->void:
	_timer.stop()

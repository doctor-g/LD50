extends Spatial

signal generated(group)

const _Obstacle := preload("res://Enemies/Obstacle.tscn")
const _Group := preload("res://Enemies/ObstacleGroup.tscn")

export var radius := 20

onready var _timer := $Timer


func _on_Timer_timeout():
	var group : Spatial = _Group.instance()
	var theta := rand_range(0, TAU)
	var pos2d := Vector2(1,0).rotated(theta) * radius
	group.translation = Vector3(pos2d.x, 0, pos2d.y)
	group.rotate(Vector3.UP, -theta)
	group.direction = Vector3(-pos2d.x, 0, -pos2d.y)
	group.speed = 1
	
	emit_signal("generated", group)


func stop()->void:
	_timer.stop()

extends Spatial

signal generated(enemy)

const _Obstacle := preload("res://Enemies/Obstacle.tscn")

export var radius := 20


func _on_Timer_timeout():
	var obstacle : Spatial = _Obstacle.instance()
	var theta := rand_range(0, TAU)
	var pos2d := Vector2(1,0).rotated(theta) * radius
	obstacle.translation = Vector3(pos2d.x, 0, pos2d.y)
	obstacle.direction = Vector3(-pos2d.x, 0, -pos2d.y)
	obstacle.speed = 1
	emit_signal("generated", obstacle)

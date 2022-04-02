extends Spatial

var direction : Vector3 setget _set_direction
var speed : float setget _set_speed


func _physics_process(_delta):
	# When this group is empty, remove it, so we don't build up garbage in memory
	if get_child_count()==0:
		queue_free()


func _set_direction(value:Vector3)->void:
	direction = value
	for obstacle in get_children():
		obstacle.direction = direction


func _set_speed(value:float)->void:
	speed = value
	for obstacle in get_children():
		obstacle.speed = speed

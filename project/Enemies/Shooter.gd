extends StaticBody

# Indicates that this thing is blowing up.
signal explosion_triggered

const _Projectile := preload("res://Enemies/Projectile.tscn")

var rotation_speed := 0.3
var burst_length := 3

var _burst_rounds := 0

onready var _shot_timer := $ShotTimer
onready var _burst_timer := $BurstTimer


func _physics_process(delta):
	rotate(Vector3.UP, delta*rotation_speed)
	translate(Vector3.ZERO)


func start():
	_shoot()


func explode():
	emit_signal("explosion_triggered")
	queue_free()


func _on_ShotTimer_timeout():
	_shoot()


func _on_BurstTimer_timeout():
	_shoot()


func _shoot():
	var rotation_around_y := transform.basis.get_rotation_quat().get_euler().y
	for angle in [0, TAU/4, TAU/2, 3*TAU/4]:
		var projectile_rotation = rotation_around_y + angle
		var projectile := _Projectile.instance()
		projectile.transform.origin = transform.origin
		projectile.direction = Vector3(1,0,0).rotated(Vector3.UP, projectile_rotation)
		get_parent().add_child(projectile)

	_burst_rounds += 1
	if _burst_rounds < burst_length:
		_burst_timer.start()
	else:
		_burst_rounds = 0
		_shot_timer.start()



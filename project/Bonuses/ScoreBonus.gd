extends Area

export var points := 500
export var speed := 2.0

var _direction : Vector3

func _ready():
	# When created, move away from the center (origin)
	_direction = global_transform.origin.normalized()


func _physics_process(delta):
	translate(_direction*delta*speed)


func _on_VisibilityNotifier_screen_exited():
	queue_free()


func _on_ScoreBonus_body_entered(_body):
	# The only thing on the layer this is watching for is the player.
	Player.score += points
	queue_free()

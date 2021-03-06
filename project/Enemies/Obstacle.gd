extends KinematicBody

# Indicates that this thing is blowing up.
# The argument is the bonus it drops or null if none
signal explosion_triggered(bonus)

const _ScoreBonus := preload("res://Bonuses/ScoreBonus.tscn")
const _RegularMaterial := preload("res://Enemies/plain_obstacle.tres")
const _PointBonusMaterial := preload("res://Enemies/point_bonus_obstacle.tres")

export var direction := Vector3(0,0,1)

export var speed := 1.0
export var has_score_bonus := false
export var rotation_speed := 3.0

## Base number of points this obstacle is worth when exploded
export var points := 100

## Is this obstacle vulnerable. Off-screen obstacles cannot be destroyed
var _vulnerable := false


func _ready():
	$CSGBox.material = _PointBonusMaterial if has_score_bonus else _RegularMaterial


func _physics_process(delta):
	$CSGBox.rotate(Vector3.UP, delta*rotation_speed)
	# warning-ignore:return_value_discarded
	move_and_collide(direction*speed*delta)


func explode():
	if _vulnerable:
		var bonus : Spatial = _ScoreBonus.instance() if has_score_bonus else null
		emit_signal("explosion_triggered", bonus)
		queue_free()


func _on_VisibilityNotifier_screen_exited():
	queue_free()


func _on_BombDetectionArea_body_entered(body):
	# If we hit something on this layer, it must be a bomb, so kill it.
	body.kill()


func _on_VisibilityNotifier_screen_entered():
	_vulnerable = true

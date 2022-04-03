extends Spatial

signal generated(shooter)

const _Shooter := preload("res://Enemies/Shooter.tscn")

var min_radius := 4.0
var max_radius := 9.0
var spawn_depth := 200.0
var min_spawn_delay := 10.0
var time_of_first_spawn := 30.0
var time_of_max_spawn_rate := 120.0

onready var _timer := $Timer
onready var _tween := $Tween

func _ready():
	_timer.start(time_of_first_spawn)
	

func stop():
	_timer.stop()


func _on_Timer_timeout():
	var shooter : Spatial = _Shooter.instance()
	var radius := rand_range(min_radius, max_radius)
	var angle := randf() * TAU
	var position := Vector3(1,0,0).rotated(Vector3.UP, angle) * radius
	var spawn_position = position + Vector3(0,-spawn_depth,0)
	shooter.transform.origin = spawn_position
	emit_signal("generated", shooter)
	
	_tween.interpolate_property(shooter, "translation", 
		spawn_position, position, 0.85, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	_tween.connect("tween_all_completed", self, "_on_Tween_all_completed", [shooter], CONNECT_ONESHOT)
	_tween.start()

	var time_to_next : float = lerp(time_of_first_spawn, min_spawn_delay, \
	 	(Player.seconds - time_of_first_spawn) / (time_of_max_spawn_rate - time_of_first_spawn))
	_timer.start(time_to_next)


func _on_Tween_all_completed(shooter:Spatial)->void:
	shooter.start()

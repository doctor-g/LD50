extends Area

export var max_radius := 4
export var expand_duration := 0.3
export var collapse_duration := 0.25

onready var _shape : SphereShape = $CollisionShape.shape
onready var _sphere := $CSGSphere
onready var _tween := $Tween
onready var _sound := $AudioStreamPlayer

func _ready():
	# Vary the pitch of the explosion following a normal distribution
	var random := RandomNumberGenerator.new()
	random.seed = OS.get_system_time_msecs()
	var variation := random.randfn(0, 0.15) # parameters are mean and stddev
	_sound.pitch_scale += variation
	_sound.play()
	
	# Start the explosion visual effects
	_tween.interpolate_method(self, "_set_radius", 0.5, max_radius, expand_duration)
	_tween.start()
	# warning-ignore:return_value_discarded
	_tween.connect("tween_completed", self, "_on_expand_completed", [], CONNECT_ONESHOT)


func _on_expand_completed(_object:Object, _key:Node)->void:
	# This will only be called once, when the expansion tween is completed.
	# Hence, we start the collapse
	_tween.interpolate_method(self, "_set_radius", max_radius, 0.1, collapse_duration)
	_tween.start()
	# warning-ignore:return_value_discarded
	_tween.connect("tween_completed", self, "_on_collapse_completed")


func _on_collapse_completed(_object:Object, _key:Node)->void:
	queue_free()


func _set_radius(radius:float)->void:
	_sphere.radius = radius
	_shape.radius = radius


func _on_Explosion_body_entered(body)->void:
	if body.has_method("explode"):
		body.explode()

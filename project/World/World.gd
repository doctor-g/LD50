extends Spatial

const _Bomb := preload("res://Player/Bomb.tscn")

var _bomb : KinematicBody

func _ready():
	_spawn_bomb()


func _spawn_bomb():
	_bomb = _Bomb.instance()
	add_child(_bomb)
	# warning-ignore:return_value_discarded
	_bomb.connect("death_animation_completed", self, 
		"_on_Bomb_death_animation_completed", [], CONNECT_ONESHOT)


func _on_Bomb_death_animation_completed():
	_bomb.queue_free()
	_spawn_bomb()

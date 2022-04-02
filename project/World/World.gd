extends Spatial

const _Bomb := preload("res://Player/Bomb.tscn")
const _Explosion := preload("res://Effects/Explosion.tscn")

var _bomb : KinematicBody
var _chain := false

onready var _explosions := $Explosions


func _ready():
	_spawn_bomb()


func _physics_process(_delta):
	if _chain and _explosions.get_child_count()==0:
		_chain = 0
		_spawn_bomb()


func _spawn_bomb():
	_bomb = _Bomb.instance()
	add_child(_bomb)
	# warning-ignore:return_value_discarded
	_bomb.connect("death_animation_completed", self, 
		"_on_Bomb_death_animation_completed")
	# warning-ignore:return_value_discarded
	_bomb.connect("explosion_triggered", self, "_on_Bomb_explosion_triggered")


func _on_Bomb_death_animation_completed():
	_bomb.queue_free()
	_spawn_bomb()


func _on_Bomb_explosion_triggered():
	_blow_up(_bomb)


func _on_Obstacle_explosion_triggered(obstacle:PhysicsBody):
	_blow_up(obstacle)
	

func _blow_up(body:PhysicsBody):
	assert(body!=null)
	var explosion : Spatial = _Explosion.instance()
	_explosions.add_child(explosion)
	explosion.translate(body.transform.origin)
	_chain = true


func _on_ObstacleGenerator_generated(group:Spatial):
	add_child(group)
	for enemy in group.get_children():
		# Move the enemy to the toplevel so that explosion coordinates
		# can be properly considered in world coordinates
		enemy.set_as_toplevel(true)
		# warning-ignore:return_value_discarded	
		enemy.connect("explosion_triggered", self, "_on_Obstacle_explosion_triggered", [enemy])

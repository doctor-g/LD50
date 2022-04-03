extends Spatial

const _Bomb := preload("res://Player/Bomb.tscn")
const _Explosion := preload("res://Effects/Explosion.tscn")

var _bomb : KinematicBody
var _chain := false
var _chain_count := 0
var _playing := true

onready var _explosions := $Explosions
onready var _generator := $ObstacleGenerator
onready var _end_game_control := $EndGameControl


func _ready():
	Player.reset()
	
	# Then start the game as usual
	_spawn_bomb()


func _input(event):
	if event.is_action_pressed("pause") and _playing:
		$PauseMenu.show()


func _physics_process(_delta):
	if not _playing:
		return
	
	Player.seconds += _delta
	
	if _chain and _explosions.get_child_count()==0:
		_chain = false
		_chain_count = 0
		_spawn_bomb()


func _spawn_bomb():
	if Player.bombs==0:
		_end_game()
	else:
		Player.bombs -= 1
		_bomb = _Bomb.instance()
		add_child(_bomb)
		# warning-ignore:return_value_discarded
		_bomb.connect("death_animation_completed", self, 
			"_on_Bomb_death_animation_completed")
		# warning-ignore:return_value_discarded
		_bomb.connect("explosion_triggered", self, "_on_Bomb_explosion_triggered")


func _end_game()->void:
	_playing = false
	_generator.stop()
	_end_game_control.update_and_show()


func _on_Bomb_death_animation_completed():
	_bomb.queue_free()
	_spawn_bomb()


func _on_Bomb_explosion_triggered():
	_blow_up(_bomb)


func _on_Obstacle_explosion_triggered(bonus:Spatial, obstacle:PhysicsBody):
	_blow_up(obstacle)
	Player.score += obstacle.points
	
	if bonus!=null:
		bonus.global_transform = obstacle.global_transform
		add_child(bonus)
	

func _blow_up(body:PhysicsBody):
	assert(body!=null)
	var explosion : Spatial = _Explosion.instance()
	_explosions.add_child(explosion)
	explosion.translate(body.transform.origin)
	_chain = true
	_chain_count += 1
	if _chain_count > Player.max_chain:
		Player.max_chain = _chain_count


func _on_ObstacleGenerator_generated(group:Spatial):
	add_child(group)
	for enemy in group.get_children():
		# Move the enemy to the toplevel so that explosion coordinates
		# can be properly considered in world coordinates
		enemy.set_as_toplevel(true)
		# warning-ignore:return_value_discarded	
		enemy.connect("explosion_triggered", self, "_on_Obstacle_explosion_triggered", [enemy])


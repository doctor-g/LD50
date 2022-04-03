extends Spatial

const _Bomb := preload("res://Player/Bomb.tscn")
const _Explosion := preload("res://Effects/Explosion.tscn")
const _FloatingText := preload("res://Bonuses/FloatingText.tscn")

var _bomb : KinematicBody

# Are we processing an explosion chain?
var _chain := false

# The current number of explosions in the chain
var _chain_count := 0

var _playing := true

# How many pickups in a row between explosions/deaths
var _pickup_chain_count := 0

onready var _explosions := $Explosions
onready var _generator := $ObstacleGenerator
onready var _shooter_generator := $ShooterGenerator
onready var _end_game_control := find_node("EndGameControl")
onready var _pause_menu := find_node("PauseMenu")
onready var _floating_text_layer := $FloatingTextLayer


func _ready():
	Player.reset()
	
	# Then start the game as usual
	_spawn_bomb()
	

func _input(event):
	if event.is_action_pressed("pause") and _playing:
		_pause_menu.show()


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
		_pickup_chain_count = 0
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
	_shooter_generator.stop()
	_end_game_control.update_and_show()


func _on_Bomb_death_animation_completed():
	_bomb.queue_free()
	_spawn_bomb()


func _on_Bomb_explosion_triggered():
	_blow_up(_bomb)


func _on_Obstacle_explosion_triggered(bonus:Spatial, obstacle:PhysicsBody):
	_blow_up(obstacle)
	Player.score += 100
	
	if bonus!=null:
		bonus.global_transform = obstacle.global_transform
		add_child(bonus)
		# warning-ignore:return_value_discarded
		bonus.connect("collected", self, "_on_ScoreBonus_collected", [bonus])


func _on_Shooter_explosion_triggered(shooter:Spatial)->void:
	_blow_up(shooter)
	Player.score += 500


func _on_ScoreBonus_collected(bonus:Spatial):
	_pickup_chain_count += 1
	var bonus_points = 300 + 200 * _pickup_chain_count
	Player.score += bonus_points
	var pos :Vector2 = $Camera.unproject_position(bonus.transform.origin)
	var floating_text := _FloatingText.instance()
	floating_text.text = "+%d" % bonus_points
	floating_text.transform.origin = pos
	_floating_text_layer.add_child(floating_text)
	

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



func _on_ShooterGenerator_generated(shooter:Spatial):
	shooter.connect("explosion_triggered", self, "_on_Shooter_explosion_triggered", [shooter])
	add_child(shooter)

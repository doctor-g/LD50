extends Control

onready var _score_label := find_node("ScoreLabel")
onready var _seconds_label := find_node("SecondsLabel")
onready var _bombs_label := find_node("BombsLabel")
onready var _max_chain_label := find_node("MaxChainLabel")
onready var _next_chain_label := find_node("NextChainLabel")


func _ready():
	# warning-ignore:return_value_discarded
	Player.connect("score_changed", self, "_on_Player_score_changed")
	# warning-ignore:return_value_discarded	
	Player.connect("bombs_changed", self, "_on_Player_bombs_changed")
	# warning-ignore:return_value_discarded	
	Player.connect("max_chain_changed", self, "_on_Player_max_chain_changed")
	# warning-ignore:return_value_discarded	
	Player.connect("next_chain_changed", self, "_on_Player_next_chain_changed")
	
	_update_bombs_label(Player.bombs)
	_update_max_chain_label(Player.max_chain)
	_update_next_chain_label(Player.next_chain)


func _on_Player_score_changed(score):
	_score_label.text = str(score)


func _on_Player_bombs_changed(bombs):
	_update_bombs_label(bombs)
	

func _on_World_seconds_changed(seconds):
	# "%6.2f" means "Six total places, two after the decimal"
	_seconds_label.text = "%6.2f" % seconds


func _on_Player_max_chain_changed(chain:int)->void:
	_update_max_chain_label(chain)
	
	
func _on_Player_next_chain_changed(next:int)->void:
	_update_next_chain_label(next)


func _update_bombs_label(bombs:int)->void:
	_bombs_label.text = str(bombs)


func _update_max_chain_label(chain:int)->void:
	_max_chain_label.text = str(chain)


func _update_next_chain_label(value:int)->void:
	_next_chain_label.text = str(value)

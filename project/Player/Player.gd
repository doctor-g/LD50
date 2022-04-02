extends Node

const _DEFAULT_BOMBS := 10
const _START_NEXT_CHAIN := 1000

signal bombs_changed(bombs)
signal score_changed(score)
signal max_chain_changed(max_chain)
signal next_chain_changed(next_chain)

var bombs := _DEFAULT_BOMBS setget _set_bombs
var score := 0 setget _set_score
var max_chain := 0 setget _set_max_chain
var next_chain := _START_NEXT_CHAIN setget _set_next_chain


func reset()->void:
	bombs = _DEFAULT_BOMBS
	score = 0
	max_chain = 0
	next_chain = _START_NEXT_CHAIN


func _set_bombs(value:int)->void:
	# TODO: Once the game _can_ end, uncomment this.
	# assert(value>=0)
	bombs = value
	emit_signal("bombs_changed", bombs)


func _set_score(value:int)->void:
	assert(value>=0)
	score = value
	emit_signal("score_changed", score)
	
	if score >= next_chain:
		_set_bombs(bombs+1)
		# warning-ignore:narrowing_conversion
		_set_next_chain(next_chain * 2.5)
	
	
func _set_max_chain(value:int)->void:
	assert(value>0)
	max_chain = value
	emit_signal("max_chain_changed", max_chain)
	

func _set_next_chain(value:int)->void:
	assert(value > 0)
	next_chain = value
	emit_signal("next_chain_changed", next_chain)

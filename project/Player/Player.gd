extends Node

const _DEFAULT_BOMBS := 5
const _START_NEXT_CHAIN := 1000

signal bombs_changed(bombs)
signal score_changed(score)
signal max_chain_changed(max_chain)
signal next_chain_changed(next_chain)

var bombs := _DEFAULT_BOMBS setget _set_bombs
var score := 0 setget _set_score
var max_chain := 0 setget _set_max_chain
var next_chain := _START_NEXT_CHAIN setget _set_next_chain
var seconds := 0.0


func reset()->void:
	_set_bombs(_DEFAULT_BOMBS)
	_set_score(0)
	_set_max_chain(0)
	_set_next_chain(_START_NEXT_CHAIN)
	seconds = 0


func _set_bombs(value:int)->void:
	assert(value>=0)
	bombs = value
	emit_signal("bombs_changed", bombs)


func _set_score(value:int)->void:
	assert(value>=0)
	score = value
	emit_signal("score_changed", score)
	
	if score >= next_chain:
		$ExtendSound.play()
		_set_bombs(bombs+1)
		# warning-ignore:narrowing_conversion
		_set_next_chain(next_chain * 1.5)
	
	
func _set_max_chain(value:int)->void:
	assert(value>=0)
	max_chain = value
	emit_signal("max_chain_changed", max_chain)
	

func _set_next_chain(value:int)->void:
	assert(value > 0)
	next_chain = value
	emit_signal("next_chain_changed", next_chain)

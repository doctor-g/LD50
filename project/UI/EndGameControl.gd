extends Control

onready var _score_label := find_node("ScoreLabel")


func _on_PlayAgainButton_pressed():
	# warning-ignore:return_value_discarded	
	get_tree().change_scene("res://World/World.tscn")


func _on_MenuButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Screens/MainMenu.tscn")


## For some reason, "about_to_show" is not working, so we use this instead.
func update_and_show():
	_score_label.text = str(Player.score)
	show_modal(true)

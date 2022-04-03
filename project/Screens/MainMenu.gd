extends Control

onready var _options_dialog := $OptionsDialog

func _on_PlayButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/World.tscn")


func _on_OptionsButton_pressed():
	_options_dialog.show()


func _on_OkButton_pressed():
	_options_dialog.hide()

extends PopupDialog


func _on_ContinueButton_pressed():
	hide()


func _on_PauseMenu_visibility_changed():
	get_tree().paused = visible

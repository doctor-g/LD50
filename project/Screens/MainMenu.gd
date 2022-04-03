extends Control

onready var _options_dialog := $OptionsDialog

func _ready():
	if OS.get_name()!="HTML5":
		var button := Button.new()
		button.text = "Quit"
		$VBoxContainer/HBoxContainer.add_child(button)
		# warning-ignore:return_value_discarded
		button.connect("pressed", self, "_on_QuitButton_pressed")
		

func _on_QuitButton_pressed()->void:
	get_tree().quit()


func _on_PlayButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/World.tscn")


func _on_OptionsButton_pressed():
	_options_dialog.show()


func _on_OkButton_pressed():
	_options_dialog.hide()

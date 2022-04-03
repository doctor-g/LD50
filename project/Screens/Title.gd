extends Control


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		$AnimationPlayer.play("fly-up")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="fly-up":
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Screens/MainMenu.tscn")

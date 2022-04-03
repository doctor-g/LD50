extends VBoxContainer

onready var _music_slider := find_node("MusicSlider")
onready var _sfx_slider := find_node("SfxSlider")
onready var _fullscreen_toggle := find_node("FullscreenToggle")

func _ready()->void:
	_music_slider.bus_index = AudioServer.get_bus_index("Music")
	_sfx_slider.bus_index = AudioServer.get_bus_index("SFX")
	_fullscreen_toggle.pressed = OS.window_fullscreen


func _on_FullscreenToggle_toggled(button_pressed:bool)->void:
	OS.window_fullscreen = button_pressed

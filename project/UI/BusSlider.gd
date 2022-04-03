extends HSlider

var bus_index := 0

func _ready():
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	value = db2linear(volume_db) * 100


func _on_BusSlider_value_changed(value):
	var volume_db = linear2db(value/100.0)
	AudioServer.set_bus_volume_db(bus_index, volume_db)

extends CanvasLayer

onready var _tween := $Tween

var text : String setget _set_text

func _ready()->void:
	_tween.interpolate_property(self, "transform:origin", transform.origin, transform.origin-Vector2(0,20), 1.0)
	_tween.interpolate_property($Label, "modulate", Color.white, Color(1,1,1,0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.2)
	_tween.start()


func _set_text(value:String)->void:
	$Label.text = value


func _on_Tween_tween_all_completed():
	queue_free()

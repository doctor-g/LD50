tool
extends Spatial

export var distance := 5.0 setget _set_distance

func _set_distance(value:float)->void:
	distance = value
	$TopWall.transform.origin = Vector3(0,0,-distance)
	$BottomWall.transform.origin = Vector3(0,0,distance)
	$LeftWall.transform.origin = Vector3(-distance,0,0)
	$RightWall.transform.origin = Vector3(distance,0,0)

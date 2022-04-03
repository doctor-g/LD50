extends Area

var speed := 5.0
var direction := Vector3(1,0,0)

func _physics_process(delta):
	translate(direction*speed*delta)


func _on_VisibilityNotifier_screen_exited():
	queue_free()


func _on_Projectile_body_entered(body):
	# The only thing that's being watched for is the player, so kill it.
	body.kill()

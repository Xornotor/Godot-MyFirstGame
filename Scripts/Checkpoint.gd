extends Area2D

func _ready():
	pass

func _on_Checkpoint_body_entered(body):
	if body.name == "Player":
		body.hit_checkpoint()
		$anim.play("checked")
		$checkpointFx.play()
		$collision.queue_free()

func _on_anim_animation_finished(anim_name):
	if(anim_name == "checked"):
		$anim.play("flowing")

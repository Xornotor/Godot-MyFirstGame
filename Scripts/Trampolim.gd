extends Area2D


func _ready():
	pass

func _on_Trampolim_body_entered(body):
	body.velocity.y = body.jump_force * 1.5
	$anim.play("jump")
	$trampolineFx.play()


func _on_anim_animation_finished(anim_name):
	if(anim_name == "jump"):
		$anim.play("idle")

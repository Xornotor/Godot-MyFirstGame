extends Area2D

export var fruits = 1

func _on_items_body_entered(body):
	$anim.play("collected")
	Global.fruits += fruits

func _on_anim_animation_finished(anim_name):
	if anim_name == "collected":
		queue_free()

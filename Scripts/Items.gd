extends Area2D

export var fruits = 1

var collected_fruit = false

func _on_items_body_entered(_body):
	if !collected_fruit:
		collected_fruit = true
		$anim.play("collected")
		$collectFx.play()
		Global.fruits += fruits

func _on_anim_animation_finished(anim_name):
	if anim_name == "collected":
		queue_free()

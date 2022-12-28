extends CanvasLayer

func change_scene(path):
	$anim.play("fade")
	yield($anim, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	$anim.play_backwards("fade")

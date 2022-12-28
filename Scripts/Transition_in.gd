extends CanvasLayer

func zero_fx():
	self.visible = false

func change_scene(path, delay = 0.5):
	self.visible = true
	$transition_fx.interpolate_property($overlay, "material:shader_param/progress", 0.0, 1.0, 2.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$transition_fx.start()
	yield($transition_fx, "tween_completed")
	assert(get_tree().change_scene(path) == OK)
	

extends ColorRect

var progress = 0.0

func _progress(delta):
	material.set("shader_param/progress", progress)

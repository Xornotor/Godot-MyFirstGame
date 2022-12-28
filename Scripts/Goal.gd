extends Area2D

export var path : String

func _ready():
	pass

func _on_Goal_body_entered(body):
	if body.name == "Player":
		$confetti.emitting = true
		Transition.change_scene(path)
		Global.checkpoint_pos = 0

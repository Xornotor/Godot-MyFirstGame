extends Area2D

export var path : String

func _ready():
	pass

func _on_Goal_body_entered(body):
	if body.name == "Player":
		$Timer.start()
		$collision.queue_free()
		$confetti.emitting = true

func _on_Timer_timeout():
	Transition.change_scene(path)
	Global.checkpoint_pos = 0

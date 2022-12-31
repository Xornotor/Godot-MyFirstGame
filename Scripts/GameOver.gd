extends CanvasLayer

func _on_ButtonRetry_pressed():
	Global.player_health = 3
	Transition.change_scene("res://Levels/Level_01.tscn")

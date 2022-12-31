extends Area2D

func _on_fallzone_body_entered(body):
	if(body.name == "Player"):
		body.player_health = 0
		if(body.gameOver()) != OK:
			print("Algo deu errado!")

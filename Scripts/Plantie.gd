extends KinematicBody2D

var facing_left = true
var hitted = false
var health = 1

onready var bullet_instance = preload("res://Scenes/PlantBullet.tscn")
onready var player = Global.get("player")

func _physics_process(delta):
	_set_animation()
	
	if player:
		var distance = player.global_position.x - self.position.x
		facing_left = true if distance < 0 else false
	
	if facing_left:
		self.scale.x = 1
	else:
		self.scale.x = -1

func shoot():
	var bullet = bullet_instance.instance()
	get_parent().add_child(bullet)
	bullet.global_position = $spawnShoot.global_position
	if facing_left:
		bullet.direction = 1
	else:
		bullet.direction = -1

func _set_animation():
	var anim = "idle"
	
	if $playerDetector.overlaps_body(player):
		anim = "attack"
	else:
		anim = "idle"
		
	if hitted:
		anim = "hit"

	if $anim.assigned_animation != anim:
		$anim.play(anim)

func _on_playerDetector_body_entered(body):
	$anim.play("attack")

func _on_playerDetector_body_exited(body):
	$anim.play("idle")

func _on_hitbox_body_entered(body):
	hitted = true
	health -= 1
	body.velocity.y = body.jump_force / 2
	yield(get_tree().create_timer(0.2), "timeout")
	hitted = false
	if health <= 0:
		queue_free()
		get_node("Hitbox/collision").set_deferred("disable", true)

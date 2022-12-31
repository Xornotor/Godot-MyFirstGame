extends KinematicBody2D
class_name enemyBase

export var speed = 64
export var health = 1
var velocity = Vector2.ZERO
var move_direction = -1
var gravity = 1200
var hitted = false

func _physics_process(_delta):
	velocity.x = speed * move_direction
	velocity = move_and_slide(velocity)
	
	if move_direction == 1:
		$texture.flip_h = true
	else:
		$texture.flip_h = false
		
	if $ray_wall.is_colliding():
		$anim.play("idle")
		
	_set_animation()
	
func apply_gravity(delta):
	velocity.y += gravity * delta


func _on_anim_animation_finished(anim_name):
	if anim_name == "idle":
		$ray_wall.scale.x *= -1
		move_direction *= -1
		$anim.play("run")
		
func _set_animation():
	var anim = "run"
	
	if $ray_wall.is_colliding():
		anim = "idle"
	elif velocity.x != 0:
		anim = "run"
		
	if hitted:
		anim = "hit"

	if $anim.assigned_animation != anim:
		$anim.play(anim)

func _on_Hitbox_body_entered(body):
	hitted = true
	$hitFx.play()
	health -= 1
	body.velocity.y = body.jump_force / 2
	yield(get_tree().create_timer(0.2), "timeout")
	hitted = false
	if health <= 0:
		queue_free()
		get_node("Hitbox/collision").set_deferred("disable", true)

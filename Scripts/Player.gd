extends KinematicBody2D

var UP = Vector2.UP
var velocity = Vector2.ZERO
var move_speed = 700
var gravity = 1200
var jump_force = -480
var startup = true
var is_grounded

#var player_health = 3
var max_health = 3

var knockback_dir = 1
var knockback_int = 500
var hurted = false

var is_pushing = false

onready var raycasts = $raycasts

signal change_life(player_health)

func _ready():
	Global.set("player", self)
	connect("change_life", get_parent().get_node("HUD/HBoxContainer/HP"), "on_change_life")
	emit_signal("change_life", max_health)
	position.x = Global.checkpoint_pos + 5

func _get_input():
	velocity.x = 0
	var move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.2)
	
	if move_direction != 0:
		$texture.scale.x = move_direction
		knockback_dir = move_direction
		$steps_fx.scale.x = -move_direction
		
	if velocity.x > 1:
		$raycasts/pushRight.set_enabled(true)
	else:
		$raycasts/pushRight.set_enabled(false)
		
	if velocity.x < -1:
		$raycasts/pushLeft.set_enabled(true)
	else:
		$raycasts/pushLeft.set_enabled(false)
		
func _input(event):
	if event.is_action_pressed("jump") and is_grounded:
		velocity.y = jump_force
		$jumpFx.play()
		
func _check_is_ground():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func _set_animation():
	var anim = "idle"
	
	if !is_grounded:
		anim = "jump"
	elif velocity.x != 0 or is_pushing:
		anim = "run"
		if is_grounded:
			$steps_fx.set_emitting(true)
		
	if velocity.y > 0 and !is_grounded:
		anim = "fall"

	if hurted:
		anim = "hit"
		
	if Global.player_health <= 0:
		anim = "destroyed"

	if $anim.assigned_animation != anim:
		$anim.play(anim)

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = 0
	
	if !hurted:
		_get_input()
	
	if $raycasts/pushRight.is_colliding():
		var object = $raycasts/pushRight.get_collider()
		object.move_and_slide(Vector2(30, 0) * move_speed * delta)
		is_pushing = true
	elif $raycasts/pushLeft.is_colliding():
		var object = $raycasts/pushLeft.get_collider()
		object.move_and_slide(Vector2(-30, 0) * move_speed * delta)
		is_pushing = true
	else:
		is_pushing = false
	
	velocity = move_and_slide(velocity, UP)
	is_grounded = _check_is_ground()
	_set_animation()
	
	for platform in get_slide_count():
		var collision = get_slide_collision(platform)
		if collision.collider.has_method("collide_with"):
			collision.collider.collide_with(collision, self)

func knockback():
	if $raycasts/right.is_colliding():
		velocity.x = -knockback_int
		
	if $raycasts/left.is_colliding():
		velocity.x = knockback_int
		
	velocity = move_and_slide(velocity)

func _on_hurtbox_body_entered(_body):
	playerDamage()
		
func hit_checkpoint():
	Global.checkpoint_pos = position.x

func _on_headCollider_body_entered(body):
	if body.has_method("destroy"):
		body.destroy()

func _on_hurtbox_area_entered(_area):
	playerDamage()

func gameOver():
	if Global.player_health <= 0:
		yield(get_tree().create_timer(1.5), "timeout")
		Transition.change_scene("res://HUD/GameOver.tscn")


func _on_anim_animation_finished(anim_name):
	if(anim_name == "destroyed"):
		self.visible = false
		self.set_collision_layer_bit(0, false)
		self.set_collision_mask_bit(1, false)
		self.set_collision_mask_bit(6, false)
		#$collision.disabled = true
		$hurtbox/collision.disabled = true
		$headCollider/collision.disabled = true
		$raycasts/left.enabled = false
		$raycasts/right.enabled = false
		$raycasts/pushLeft.enabled = false
		$raycasts/pushRight.enabled = false
		$raycasts/raycast1.enabled = false
		$raycasts/raycast2.enabled = false

func playerDamage():
	Global.player_health -= 1
	hurted = true
	$hurtFx.play()
	emit_signal("change_life", Global.player_health)
	knockback()
	get_node("hurtbox/collision").set_deferred("disabled", true)
	yield(get_tree().create_timer(0.5), "timeout")
	get_node("hurtbox/collision").set_deferred("disabled", false)
	hurted = false
	gameOver()

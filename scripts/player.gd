extends CharacterBody2D

var current_dir = "none"
const speed = 100
const max_health = 200
var health = max_health

var enemy_inrange = false
var enemy_atk_cooldown = true
var player_alive = true
var attacking = false

var regen_timer_active = true

func _ready():
	$AnimatedSprite2D.play("idle_back")


func _physics_process(delta):
	palyer_movement(delta)
	enemy_attack()
	attack()
	update_health()
	
	if health <= 0:
		player_alive = false
		health = 0
		print("Player Died")
		
		self.queue_free()
	
func palyer_movement(delta):
	# Down Right
	if Input.is_key_pressed(KEY_S) and Input.is_key_pressed(KEY_D):
		current_dir = "right"
		play_anim(1)
		velocity.x = (speed * 2)/3
		velocity.y = (speed * 2)/3
	
	# Down Left
	elif Input.is_key_pressed(KEY_S) and Input.is_key_pressed(KEY_A):
		current_dir = "left"
		play_anim(1)
		velocity.x = -(speed * 2)/3
		velocity.y = (speed * 2)/3 
		
	# Up Right
	elif Input.is_key_pressed(KEY_W) and Input.is_key_pressed(KEY_D):
		current_dir = "right"
		play_anim(1)
		velocity.x = (speed * 2)/3
		velocity.y = -(speed * 2)/3
		
	# Up Left
	elif Input.is_key_pressed(KEY_W) and Input.is_key_pressed(KEY_A):
		current_dir = "left"
		play_anim(1)
		velocity.x = -(speed * 2)/3
		velocity.y = -(speed * 2)/3
		
	# Right
	elif Input.is_key_pressed(KEY_D):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
		
	#Left
	elif Input.is_key_pressed(KEY_A):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
		
	# Down
	elif Input.is_key_pressed(KEY_S):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
		
	# Up
	elif Input.is_key_pressed(KEY_W):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
		
	# Idle
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_side")
		elif movement == 0:
			if attacking == false:
				anim.play("idle_side")
			
			
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("walk_side")
		elif movement == 0:
			if attacking == false:
				anim.play("idle_side")

	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_front")
		elif movement == 0:
			if attacking == false:
				anim.play("idle_front")

	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_back")
		elif movement == 0:
			if attacking == false:
				anim.play("idle_back")

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inrange = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inrange = false

func enemy_attack():
	if enemy_inrange and enemy_atk_cooldown == true:
		health = health - 10
		enemy_atk_cooldown = false
		$atk_cooldown.start()
		regen_timer_active = false
		print("-10, Remaining Health: ", health)

func _on_atk_cooldown_timeout():
	enemy_atk_cooldown = true
	regen_timer_active = true

func attack():
	var dir = current_dir
	if Input.is_action_just_pressed("attack"):
		global.player_curr_atk = true
		attacking = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("atk_side")
			$deal_atk_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("atk_side")
			$deal_atk_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("atk_back")
			$deal_atk_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("atk_front")
			$deal_atk_timer.start()

func _on_deal_atk_timer_timeout():
	$deal_atk_timer.stop()
	global.player_curr_atk = false
	attacking = false

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= max_health:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout():
	if regen_timer_active and health < max_health:
		health = health + 20
		if health > max_health:
			health = max_health 
	if health <= 0:
		health = 0

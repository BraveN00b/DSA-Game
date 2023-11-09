extends CharacterBody2D

var speed = 60
var player_chase = false
var player = null
var health = 100
var player_inrange = false


func _physics_process(delta):
	deal_with_damage()
	
	if player_chase:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		
		move_and_collide(Vector2(0,0))

		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("side")


func _on_detection_body_entered(body):
	player = body
	player_chase = true


func _on_detection_body_exited(body):
	player = null
	player_chase = false

func enemy():
	pass


func _on_slime_hitbox_body_entered(body):
	if body.has_method("palyer"):
		player_inrange = true


func _on_slime_hitbox_body_exited(body):
	if body.has_method("palyer"):
		player_inrange = false
		
func deal_with_damage():
	if player_inrange and global.player_curr_atk == true:
		health = health - 20
		print("-20 Slime Health Remaining: ", health)
		if health <= 0:
			print("Slime Killed!")
			self.queue_free()

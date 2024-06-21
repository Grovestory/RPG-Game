extends CharacterBody2D

var speed = 25
var player_chase = false
var player = null

var health = 100
var player_Inattack_zone = false 
var can_take_damage = true
var can_deal_damage = true

func _physics_process(delta):
	deal_with_damage()
	deal_damage_to_player()
	
	if player_chase:
		position += (player.position - position) / speed

		$AnimatedSprite2D.play("walk")
		
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")
	move_and_collide(Vector2(0, 0))

func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player = body
		player_chase = true

func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		player = null
		player_chase = false

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_Inattack_zone = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_Inattack_zone = false

func deal_with_damage():
	if player_Inattack_zone and Global.player_current_attack == true:
		if can_take_damage:
			health -= 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("slime health = ", health)
			if health <= 0:
				self.queue_free()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

#crashes game on death
func deal_damage_to_player():
	if player_Inattack_zone and can_deal_damage:
		if player and player.has_method("take_damage"):  # Assume player has a take_damage method
			player.take_damage(20)
			$deal_damage_cooldown.start()
			can_deal_damage = false

func _on_deal_damage_cooldown_timeout():
	can_deal_damage = true

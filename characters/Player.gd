extends KinematicBody2D

signal laser_shoot
signal player_died

var player_explosion_scene := load("res://objects/ParticlesPlayerExplosion.tscn")

const SPEED = 600

func explode():
	var explosion = player_explosion_scene.instance()
	explosion.position = self.position
	get_parent().add_child(explosion)
	explosion.emitting = true
	
	emit_signal("player_died")
	
	queue_free()

func _physics_process(delta : float) -> void:
	var velocity := Vector2()
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
		# Not used in this version of the game; planned updates will need this input
#	if Input.is_action_pressed("ui_up"):
#		velocity.y -= SPEED
#	if Input.is_action_pressed("ui_down"):
#		velocity.y += SPEED
	
# warning-ignore:return_value_discarded
	move_and_collide(velocity * delta)

func _ready() -> void:
	var camera = get_parent().get_node("MainCamera")
# warning-ignore:return_value_discarded
	self.connect("laser_shoot", camera, "_on_Player_laser_shoot")
	
	var game = get_parent()
# warning-ignore:return_value_discarded
	self.connect("player_died", game, "_on_Player_player_died")

func _unhandled_key_input(event):
	if event.is_action_pressed("shoot"):
		$LaserWeapon.shoot()
		emit_signal("laser_shoot")














func _on_Hitbox_body_entered(body: Node) -> void:
	if not self.is_queued_for_deletion() and body.is_in_group("asteroids"):
		explode()

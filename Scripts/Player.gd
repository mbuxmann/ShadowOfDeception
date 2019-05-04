extends KinematicBody2D

var velocity = Vector2()
var jumped = false
var on_ground = false
var canAttack = true
var is_attacking = false
var direction = 0
var anim_state = null
var is_anim_finished = true
var playerPosition = null
var zoom = false

const RUNSPEED: int = 100
const JUMP_POWER: int = -250
const FLOOR = Vector2(0, -1)
const GRAVITY: int = 10

signal rotateMirror
signal hitFireball
signal changeLever
signal sendJump

enum {
	player_idle,
	player_attackLeft,
	player_attackRight,
	player_jumping,
	player_falling,
	player_jumped,
	player_run
}

func _ready():
	playerPosition = $Position2D.position

func _physics_process(delta):
	check_on_floor()
	get_input()
	get_animation()
	out_of_bounds()

	velocity.y += GRAVITY

	move_and_slide(velocity, FLOOR)


func check_on_floor() -> void:
	if is_on_floor():
		on_ground = true
		velocity.y = 0
	elif is_on_ceiling():
		velocity.y = 0
	else:
		on_ground = false

func get_input() -> void:
	if Input.is_action_pressed('Left') && !Input.is_action_pressed('Right'):
		velocity.x = -RUNSPEED
		$Sprite.flip_h = true
		direction = -1
	elif Input.is_action_pressed('Right') && !Input.is_action_pressed('Left'):
		velocity.x = RUNSPEED
		$Sprite.flip_h = false
		direction = 1
	else:
		velocity.x = 0
	
	if Input.is_action_pressed('Jump') && on_ground:
		velocity.y = JUMP_POWER
		on_ground = false
		jumped = true
		if $RayCast2DDown.is_colliding():
			var collidedWithObject = $RayCast2DDown.get_collider()
			if collidedWithObject.collision_layer == 256:
				sendJump()
	
	
	if Input.is_action_pressed('Attack') && (direction == -1):
		var collidedWithObject = $RayCastToLeft.get_collider()
		if !$RayCastToLeft.is_colliding() && canAttack:
			$Sounds/AttackAir.play()
		elif $RayCastToLeft.is_colliding():
			if collidedWithObject.collision_layer == 4:
				rotateMirror(collidedWithObject.get_name())
			elif collidedWithObject.collision_layer == 8:
				hitFireball(collidedWithObject.get_name())
			elif collidedWithObject.collision_layer == 64:
				changeLever(collidedWithObject.get_name())
	
	elif Input.is_action_pressed('Attack') && (direction == 1):
		var collidedWithObject = $RayCastToRight.get_collider()
		if !$RayCastToRight.is_colliding() && canAttack:
			$Sounds/AttackAir.play()
		elif $RayCastToRight.is_colliding():
			if collidedWithObject.collision_layer == 4:
				rotateMirror(collidedWithObject.get_name())
			elif collidedWithObject.collision_layer == 8:
				hitFireball(collidedWithObject.get_name())
			elif collidedWithObject.collision_layer == 64:
				changeLever(collidedWithObject.get_name())
	
func get_animation() -> void:
	if is_anim_finished == true:
		if Input.is_action_pressed('Attack') && canAttack:
			if direction == -1:
				playAnimation('playerAttackLeft', player_attackLeft)
				canAttack = false
				is_attacking = true
			elif direction == 1:
				playAnimation('playerAttackRight', player_attackRight)
				canAttack = false
				is_attacking = true
		elif Input.is_action_just_pressed('Jump') && !jumped && canAttack:
			playAnimation('playerJumping', player_jumping)
		elif !on_ground:
			if velocity.y > 0:
				playAnimation('playerFalling', player_falling)
			elif velocity.y < 0:
				playAnimation('playerJumped', player_jumped)
				
		elif (Input.is_action_pressed('Left') || Input.is_action_pressed('Right')) && !is_attacking:
			playAnimation('playerRun', player_run)
		elif !Input.is_action_pressed('Left') && !Input.is_action_pressed('Right') && !is_attacking:
			playAnimation('playerIdle', player_idle)

func out_of_bounds():
	if position.x < 8:
		position.x = 8
	elif position.x > 521:
		position.x = 521
	if position.y > 300:
		position = playerPosition
# Handles AnimationPlayer and check if animation has finished

func playAnimation(animation, playerState):
	if playerState == player_attackLeft:
		$AnimationPlayer.play(animation)
		is_anim_finished = false
		return
	elif playerState == player_attackRight:
		$AnimationPlayer.play(animation)
		is_anim_finished = false
		return
	elif playerState == player_jumping:
		$AnimationPlayer.play(animation)
	elif playerState == player_falling:
		$AnimationPlayer.play(animation)
	elif playerState == player_jumped:
		$AnimationPlayer.play(animation)
	elif playerState == player_run:
		$AnimationPlayer.play(animation)
	elif playerState == player_idle:
		$AnimationPlayer.play(animation)
		
	_on_AnimationPlayer_animation_finished(animation)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	canAttack = true
	is_attacking = false
	is_anim_finished = true

func _on_Spring_makePlayerJump(jumpForce):
	velocity.y = -jumpForce

# Rotate Mirrors by 90 degrees through signal

func rotateMirror(mirrorName):
	_connect_mirror_signal('../Mirrors/' + mirrorName)
	emit_signal('rotateMirror')
	_disconnect_mirror_signal('../Mirrors/' + mirrorName)

func _connect_mirror_signal(mirror):
	var mirrorNode = get_node(mirror)
	self.connect('rotateMirror', mirrorNode, '_on_Player_rotateMirror', [canAttack])

func _disconnect_mirror_signal(mirror):
	var mirrorNode = get_node(mirror)
	self.disconnect('rotateMirror', mirrorNode, '_on_Player_rotateMirror')
	
# Shoot fireball through signal
func hitFireball(fireballName):
	_connect_fireball_signal('../Fireballs/' + fireballName)
	emit_signal('hitFireball')
	_disconnect_fireball_signal('../Fireballs/' + fireballName)

func _connect_fireball_signal(fireball):
	var fireballNode = get_node(fireball)
	self.connect('hitFireball', fireballNode, '_on_Player_hitFireball', [direction])

func _disconnect_fireball_signal(fireball):
	var fireballNode = get_node(fireball)
	self.disconnect('hitFireball', fireballNode, '_on_Player_hitFireball')

# Change lever through Signal
func changeLever(leverName):
	_connect_changeLever_signal('../Levers/' + leverName)
	emit_signal('changeLever')
	_disconnect_changeLever_signal('../Levers/' + leverName)

func _connect_changeLever_signal(lever):
	var leverNode = get_node(lever)
	self.connect('changeLever', leverNode, '_on_Player_changeLever', [canAttack])

func _disconnect_changeLever_signal(lever):
	var leverNode = get_node(lever)
	self.disconnect('changeLever', leverNode, '_on_Player_changeLever')
	
# send Jump signal to Spring
func sendJump():
	emit_signal('sendJump')
	
extends Area2D

const SPEED = 100
var velocity = Vector2()
var directionX = 0
var directionY = 0
var originalPos = Vector2()
var newPosition = Vector2()

func _ready():
	originalPos = $Position2D.global_position
	set_physics_process(false)
	$AnimationPlayer.play('flameIdle')
	
	
func _physics_process(delta):
	if velocity.x > 0:
		rotation_degrees = -90
	if velocity.x < 0:
		rotation_degrees = 90
	if velocity.y < 0:
		rotation_degrees = 180
	if velocity.y > 0:
		rotation_degrees = 0
		
	velocity.x = SPEED * delta * directionX
	velocity.y = SPEED * delta * directionY
	translate(velocity)
	
func _on_Player_hitFireball(dir):
	$Sounds/FireAttacked.play()
	set_physics_process(true)
	directionX = dir
	
func _on_Mirror_resetFireball(fireballNode):
	$Sounds/FireballImpact.play()
	var fireball = fireballNode
	fireball.set_position(originalPos)
	set_physics_process(false)
	directionX = 0
	directionY = 0
	rotation_degrees = 0
	
func _on_Mirror_rotateFireball(dirX, dirY):
	directionX = dirX
	directionY = dirY
	
func _on_Mirror_setPositionFireball(fireballNode, newPosition):
	var fireball = fireballNode
	fireball.set_position(newPosition)
	
func _on_VisibilityEnabler2D_screen_exited():
	set_position(originalPos)
	set_physics_process(false)
	directionX = 0
	directionY = 0
	rotation_degrees = 0

func _on_Receiver_destroyFireball(fireballNode):
	queue_free()
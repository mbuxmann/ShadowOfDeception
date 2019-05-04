extends Area2D

export var angle  = 0
var SetFireballdirX = 0
var SetFireballdirY = 0
var newFireballPosition = Vector2()

signal resetFireball
signal rotateFireball
signal setPositionFireball


func _ready():
	rotation_degrees = angle
	$AnimationPlayer.play('idleMirror')
	
func _physics_process(delta):
	newFireballPosition = $Position2D.global_position	

	#sets fireball's direction and position
	
	if angle == 0:
		if $RayCastUp.is_colliding():
			SetFireballdirX = 1
			SetFireballdirY = 0
			newFireballPosition.x += 20
		if $RayCastRight.is_colliding():
			SetFireballdirX = 0
			SetFireballdirY = -1
			newFireballPosition.y += -20
	elif angle == 90:
		if $RayCastUp.is_colliding():
			SetFireballdirX = 0
			SetFireballdirY = 1
			newFireballPosition.y += 20
		if $RayCastRight.is_colliding():
			SetFireballdirX = 1
			SetFireballdirY = 0
			newFireballPosition.x += 20
	elif angle == 180:
		if $RayCastUp.is_colliding():
			SetFireballdirX = -1
			SetFireballdirY = 0
			newFireballPosition.x += -20
		if $RayCastRight.is_colliding():
			SetFireballdirX = 0
			SetFireballdirY = 1
			newFireballPosition.y += 20
	elif angle == 270:
		if $RayCastUp.is_colliding():
			SetFireballdirX = 0
			SetFireballdirY = -1
			newFireballPosition.y += -20
		if $RayCastRight.is_colliding():
			SetFireballdirX = -1
			SetFireballdirY = 0
			newFireballPosition.x += -20

	#resets fireball or rotate's it 
	
	if $RayCastLeft.is_colliding():
		var collidedWithObject = $RayCastLeft.get_collider()
		resetFireball(collidedWithObject.get_name())
	elif $RayCastDown.is_colliding():
		var collidedWithObject = $RayCastDown.get_collider()
		resetFireball(collidedWithObject.get_name())
	elif $RayCastRight.is_colliding():
		var collidedWithObject = $RayCastRight.get_collider()
		rotateFireball(collidedWithObject.get_name())
		setPositionFireball(collidedWithObject.get_name())
		succesfullHit()
	elif $RayCastUp.is_colliding():
		var collidedWithObject = $RayCastUp.get_collider()
		rotateFireball(collidedWithObject.get_name())
		setPositionFireball(collidedWithObject.get_name())
		succesfullHit()
	
func succesfullHit():
	$Sounds/MirrorImpact.play()
	$AnimationPlayer.play('MirrorHit')
	
func _on_Player_rotateMirror(canAttack):
	if canAttack == true:
		angle += 90
		if angle == 360:
			angle = 0
		rotation_degrees = angle
		$Sounds/MirrorAttacked.play()
		
		
func resetFireball(fireballName):
	_connect_resetfireball_signal('../../Fireballs/' + fireballName)
	emit_signal('resetFireball')
	_disconnect_resetfireball_signal('../../Fireballs/' + fireballName)

func _connect_resetfireball_signal(fireball):
	var fireballNode = get_node(fireball)
	self.connect('resetFireball', fireballNode, '_on_Mirror_resetFireball', [fireballNode])

func _disconnect_resetfireball_signal(fireball):
	var fireballNode = get_node(fireball)
	self.disconnect('resetFireball', fireballNode, '_on_Mirror_resetFireball')
	
# Rotate Fireball

func rotateFireball(fireballName):
	_connect_rotateFireball_signal('../../Fireballs/' + fireballName)
	emit_signal('rotateFireball')
	_disconnect_rotateFireball_signal('../../Fireballs/' + fireballName)
	
func _connect_rotateFireball_signal(fireball):
	var fireballNode = get_node(fireball)
	self.connect('rotateFireball', fireballNode, '_on_Mirror_rotateFireball', [SetFireballdirX, SetFireballdirY])

func _disconnect_rotateFireball_signal(fireball):
	var fireballNode = get_node(fireball)
	self.disconnect('rotateFireball', fireballNode, '_on_Mirror_rotateFireball')

	
# Set Fireball Position
func setPositionFireball(fireballName):
	_connect_setPositionFireball_signal('../../Fireballs/' + fireballName)
	emit_signal('setPositionFireball')
	_disconnect_setPositionFireball_signal('../../Fireballs/' + fireballName)
	
func _connect_setPositionFireball_signal(fireball):
	var fireballNode = get_node(fireball)
	self.connect('setPositionFireball', fireballNode, '_on_Mirror_setPositionFireball', [fireballNode, newFireballPosition])

func _disconnect_setPositionFireball_signal(fireball):
	var fireballNode = get_node(fireball)
	self.disconnect('setPositionFireball', fireballNode, '_on_Mirror_setPositionFireball')


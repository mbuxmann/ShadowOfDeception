extends StaticBody2D

export var jumpForce = 0

signal makePlayerJump

func _ready():
	$AnimationPlayer.play('springInactive')

func _physics_process(delta):
	if $RayCast2D.is_colliding():
		var collidedWithObject = $RayCast2D.get_collider()
		if collidedWithObject.get_name() == "Player":
			makePlayerJump(collidedWithObject.get_name())

func _on_Player_sendJump():
	$Sounds/Spring.play()
	$AnimationPlayer.play('springActivate')


func makePlayerJump(player):
	_connect_makePlayerJump_signal('../../' + player)
	emit_signal('makePlayerJump')
	_disconnect_makePlayerJump_signal('../../' + player)
	
func _connect_makePlayerJump_signal(player):
	var playerNode = get_node(player)
	self.connect('makePlayerJump', playerNode, '_on_Spring_makePlayerJump', [jumpForce])

func _disconnect_makePlayerJump_signal(player):
	var playerNode = get_node(player)
	self.disconnect('makePlayerJump', playerNode, '_on_Spring_makePlayerJump')


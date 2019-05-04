extends StaticBody2D


func _ready():
	$AnimationPlayer.play('gateClosed')



func _on_lever_changeGateState(leverStateOn):
	if !leverStateOn:
		$AnimationPlayer.play("gateClosing")
		$CollisionShape2D.disabled = false
		$Sounds/GateClosed.play()
	elif leverStateOn:
		$AnimationPlayer.play('gateOpening')
		$CollisionShape2D.disabled = true
		$Sounds/GateOpened.play()
	
	
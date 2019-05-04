extends StaticBody2D



func _ready():
	$AnimationPlayer.play('platformCollapsed')

func _physics_process(delta):
	pass
	
func _on_Receiver_puzzleCompleted():
#	$Sounds/FoldablePlatformOpening.play()
	$AnimationPlayer.play('PlatformActivated')
	$CollisionShape2D.disabled = false
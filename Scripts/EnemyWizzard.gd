extends KinematicBody2D

var x = -160
var y = -40
var velocity = Vector2()
var introDone = false

func _ready():
	$AnimatedSprite.play('wizzardIdle')
	set_physics_process(false)
	
func _physics_process(delta):

	if position.x > 40:
		$AnimatedSprite.play('wizzardMove')
		velocity.x = x
		move_and_slide(velocity) 


func _on_StartBoss_startBoss():
	set_physics_process(true)
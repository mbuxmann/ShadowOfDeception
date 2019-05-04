extends Area2D

export(String, FILE) var nextLevel
export(String, FILE) var currentLevel


func _physics_process(delta):
	if Input.is_action_just_pressed('ResetLevel'):
		get_tree().change_scene(currentLevel)



func _on_Portal_body_entered(body):
	if body.get_name() == 'Player':
		get_tree().change_scene(nextLevel)


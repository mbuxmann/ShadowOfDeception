extends Area2D

onready var bossNode = 'res://Scenes/Characters/EnemyWizzard.tscn'

signal startBoss

func _on_StartBoss_body_entered(body):
	if body.get_name() == 'Player':
		emit_signal('startBoss')
		



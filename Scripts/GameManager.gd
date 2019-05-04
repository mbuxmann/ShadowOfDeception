extends Node2D

func _ready():
	$AudioStreamPlayer.play()

func _process(delta):
	if Input.is_action_just_pressed('esc'):
		get_tree().change_scene('res://Scenes/TitleScreen.tscn')
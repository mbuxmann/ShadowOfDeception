extends Control

func _on_TextureButton_pressed():
	get_tree().change_scene('res://Scenes/Levels/Level000.tscn')


func _on_ExitGameBtn_pressed():
	get_tree().quit()

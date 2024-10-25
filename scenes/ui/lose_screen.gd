extends Control

signal give_up_button_pressed


func _on_give_up_button_pressed():
	give_up_button_pressed.emit()


func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")

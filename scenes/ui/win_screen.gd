extends Control

signal give_up_button_pressed


func _on_give_up_button_pressed():
	emit_signal("give_up_button_pressed")

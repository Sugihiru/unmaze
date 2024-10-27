extends Control

signal give_up_button_pressed
signal continue_button_pressed


func _on_continue_button_pressed():
	continue_button_pressed.emit()

func _on_give_up_button_pressed():
	give_up_button_pressed.emit()

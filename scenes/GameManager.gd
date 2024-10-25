extends Node

var nb_players = 1

signal player_won
signal player_lost

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_player_stairs_found():
	nb_players -= 1
	if nb_players == 0:
		player_won.emit()


func _on_player_won():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_give_up_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")


func _on_monster_player_hit():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player_lost.emit()

extends Node

var nb_players = 1

signal player_won
signal player_lost

enum GameState {PLAYING, GAME_OVER}

var current_game_state = GameState.PLAYING

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false

func _input(event: InputEvent):
	if current_game_state != GameState.PLAYING:
		return
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_player_stairs_found():
	player_won.emit()


func _on_player_won():
	current_game_state = GameState.GAME_OVER
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_give_up_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")


func _on_monster_player_hit():
	current_game_state = GameState.GAME_OVER
	player_lost.emit()
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_win_screen_continue_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")

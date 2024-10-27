extends Node


@onready var win_screen = $WinScreen
@onready var transition_lose_screen = $TransitionLoseScreen
@onready var lose_screen = $LoseScreen


func _on_game_manager_player_won():
	win_screen.visible = true


func _on_game_manager_player_lost():
	transition_lose_screen.visible = true
	await get_tree().create_timer(1.0).timeout
	transition_lose_screen.visible = false
	lose_screen.visible = true

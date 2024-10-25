extends Node


@onready var win_screen = $WinScreen
@onready var lose_screen = $LoseScreen


func _on_game_manager_player_won():
	win_screen.visible = true


func _on_game_manager_player_lost():
	lose_screen.visible = true

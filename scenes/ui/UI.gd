extends Node


@onready var win_screen = $WinScreen


func _on_game_manager_player_won():
	win_screen.visible = true

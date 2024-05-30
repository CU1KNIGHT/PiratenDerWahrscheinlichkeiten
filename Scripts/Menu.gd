extends Control



func _on_spielen_pressed():
	get_tree().change_scene_to_file("res://game.tscn")


func _on_optionen_pressed():
	get_tree().change_scene_to_file("res://options_menu.tscn")


func _on_schließen_pressed():
	get_tree().quit()

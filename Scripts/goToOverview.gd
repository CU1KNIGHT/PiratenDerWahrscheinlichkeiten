extends Button

func _on_pressed():
	get_tree().change_scene_to_file(Global.global_current_overview_scene_path)

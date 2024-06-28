extends TextureButton

func _pressed():
	Global.global_current_overview_scene_path=Global.EIS_OVERVIEW_SCENE_PATH
	get_tree().change_scene_to_file(Global.EIS_OVERVIEW_SCENE_PATH)

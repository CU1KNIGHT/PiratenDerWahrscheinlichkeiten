extends TextureButton


func _pressed():
	Global.global_current_island="lapalce-island"
	get_tree().change_scene_to_file(Global.EXPLANATION_SCENE_PATH)

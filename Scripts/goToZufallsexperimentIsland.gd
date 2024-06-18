extends TextureButton


func _pressed():
	Global.global_current_island="Grundlage-Zufallsexperiment"
	get_tree().change_scene_to_file("res://Scenes/grundlage/zufallsexperiment.tscn")

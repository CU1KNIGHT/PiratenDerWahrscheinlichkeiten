extends TextureButton


func _pressed():
	Global.global_current_island="Grundlage-Gegenereignis"
	get_tree().change_scene_to_file("res://Scenes/grundlage/gegenereignisse.tscn")

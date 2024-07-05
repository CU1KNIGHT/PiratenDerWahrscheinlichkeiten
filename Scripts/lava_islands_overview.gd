extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.global_current_overview_scene_path=Global.LAVA_OVERVIEW_SCENE_PATH
	Global.current_questions_file_path=Global.Q3
	Global.lava=true
	if Global.is_the_game_finshed:
		$treasure.show()
	else:
		$treasure.hide()
		


func _on_nach_eis_insel_pressed():
	get_tree().change_scene_to_file("res://scenes/ice_islands_overview.tscn")

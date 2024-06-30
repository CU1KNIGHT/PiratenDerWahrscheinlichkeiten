extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.is_the_game_finshed:
		$treasure.show()
	else:
		$treasure.hide()
		


func _on_nach_ei_insel_pressed():
	get_tree().change_scene_to_file("res://scenes/ice_islands_overview.tscn")

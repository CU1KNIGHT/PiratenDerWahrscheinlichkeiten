extends Node2D

@onready var pause_menu = $PauseMenu
var paused = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.currentLevelSceneTasks=Global.INPUT_FIELD_TASKS_LAVAL_SCENE_PATH
	Global.global_current_overview_scene_path=Global.LAVA_OVERVIEW_SCENE_PATH
	Global.current_questions_file_path=Global.Q3
	Global.lava=true
	if Global.is_the_game_finshed:
		$treasure.show()
	else:
		$treasure.hide()
		


func _on_nach_eis_insel_pressed():
	get_tree().change_scene_to_file("res://scenes/ice_islands_overview.tscn")


func _on_pause_pressed():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused  

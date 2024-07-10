extends Node2D

@onready var pause_menu = $PauseMenu
var paused = false

var nachLavaInsel=null

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.currentLevelSceneTasks=Global.MULTICHOICE_EIS_SCENE_PATH
	$Pause.connect("pressed",Callable(self, "_on_pause_pressed"))
	$"die Eis Inseln".connect("pressed",Callable(self, "_on_die_eis_inseln_pressed"))
		
	nachLavaInsel=$"nach Lava Insel"
	if(Global.lava):
		nachLavaInsel.show()
	else:
		nachLavaInsel.hide()
		
		
func _on_pause_pressed():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused  
	



func _on_nach_grundlagen_insel_pressed():
	get_tree().change_scene_to_file("res://scenes/basic_islands_overview.tscn")
	
func _on_die_eis_inseln_pressed():
	get_tree().change_scene_to_file(Global.currentLevelSceneTasks)

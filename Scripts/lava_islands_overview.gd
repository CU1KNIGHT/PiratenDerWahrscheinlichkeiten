extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.is_the_game_finshed:
		$treasure.show()
	else:
		$treasure.hide()
		

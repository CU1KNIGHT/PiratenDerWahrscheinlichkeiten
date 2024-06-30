extends Node2D
var nachLavaInsel=null

# Called when the node enters the scene tree for the first time.
func _ready():
	nachLavaInsel=$"nach Lava Insel"
	if(Global.lava):
		nachLavaInsel.show()
	else:
		nachLavaInsel.hide()
	


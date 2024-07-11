extends Control

@onready var masterButtonSprite = $masterButtonSprite
@onready var musicButtonSprite = $musicButtonSprite
@onready var sfxButtonSprite = $sfxButtonSprite

@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
var frageLimit=null

func _ready():
	print("questoinsLimit: "+str(Global.questoinsLimit))
	frageLimit=$question_limit
	frageLimit.connect("text_changed", Callable(self, "_on_text_changed"))
	frageLimit.text=str(Global.questoinsLimit)
	if AudioServer.is_bus_mute(MASTER_BUS_ID):
		masterButtonSprite.play("muted")
	else :
		masterButtonSprite.play("unmuted")
	
	if AudioServer.is_bus_mute(MUSIC_BUS_ID):
		musicButtonSprite.play("muted")
	else:
		musicButtonSprite.play("unmuted")
		
	if AudioServer.is_bus_mute(SFX_BUS_ID):
		sfxButtonSprite.play("muted")
	else:
		sfxButtonSprite.play("unmuted")

func _on_text_changed():
	Global.questoinsLimit=int(frageLimit.text)
	print(Global.questoinsLimit)
	
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")



func _on_master_button_pressed():
	if masterButtonSprite.animation == "muted":
		masterButtonSprite.play("unmuted")
		AudioServer.set_bus_mute(MASTER_BUS_ID, false)
	else:
		masterButtonSprite.play("muted")
		AudioServer.set_bus_mute(MASTER_BUS_ID, true)
		


func _on_music_button_pressed():
	if musicButtonSprite.animation == "muted":
		musicButtonSprite.play("unmuted")
		AudioServer.set_bus_mute(MUSIC_BUS_ID, false)
	else:
		musicButtonSprite.play("muted")
		AudioServer.set_bus_mute(MUSIC_BUS_ID, true)
		
		



func _on_sfx_button_pressed():
	if sfxButtonSprite.animation == "muted":
		sfxButtonSprite.play("unmuted")
		AudioServer.set_bus_mute(SFX_BUS_ID, false)
	else:
		sfxButtonSprite.play("muted")
		AudioServer.set_bus_mute(SFX_BUS_ID, true)
		

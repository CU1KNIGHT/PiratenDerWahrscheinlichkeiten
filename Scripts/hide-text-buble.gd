extends TextureButton

var richt_text_bubble
func _read():
	richt_text_bubble=$
func _pressed():
	richt_text_bubble.visible = !richt_text_bubble.visible

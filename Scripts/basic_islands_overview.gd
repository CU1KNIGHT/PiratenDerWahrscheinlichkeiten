extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
		
	var texture_buttons = get_all_texture_buttons(self)
	# Loop through each TextureButton and compare its name with the dictionary keys
	for button in texture_buttons:
		if Global.basics_islands.has(button.name):
			if Global.basics_islands[button.name]:
				button.show()
			else:
				button.hide()
		else:
			# Optionally, hide buttons not found in the dictionary
			button.hide()
	var nach_eis_insel_button=$"nach Eis Insel"
	print("global.eis: "+str(Global.eis))
	if(Global.eis ==true):
		nach_eis_insel_button.show()
	else:
		nach_eis_insel_button.hide()

func get_all_texture_buttons(root):
	var texture_buttons = []
	_collect_texture_buttons_recursive(root, texture_buttons)
	return texture_buttons

# Recursive helper function to collect TextureButton nodes
func _collect_texture_buttons_recursive(node, texture_buttons):
	if node is TextureButton:
		texture_buttons.append(node)
	for child in node.get_children():
		_collect_texture_buttons_recursive(child, texture_buttons)	
		



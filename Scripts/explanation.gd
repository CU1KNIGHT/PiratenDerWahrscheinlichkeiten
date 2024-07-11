extends Node2D

@onready var pause_menu = $PauseMenu
var paused = false

var island_names_mapper_file_path = "res://Scripts/jsonFiles/islandsMap.json"
var island_names_mapper = null

var answers_file_path = "res://resources/Game-Task-and-Questions/Tasks/user_answers.csv1"
var column_mapping_file_path = "res://Scripts/jsonFiles/column_mapping.json"
var questions = []
var current_question = {}
var total_correct = 0
var asked_indices = []
var islands_subject_map = {}
var current_island = "Grundlage-Wahrscheinlichkeiten"
var filterQuestions=[]
var doneButton = null
var nextButton = null
var buttonAtexture=null
var buttonBtexture=null
var buttonCtexture=null
var buttonDtexture=null
var buttonA=null
var buttonB=null
var buttonC=null
var buttonD=null
var rightIcon = "res://resources/Game UI Design/icons/right.svg"
var wrongIcon = "res://resources/Game UI Design/icons/false.svg"
var texture_rect = null
var initTextureRectButtonA=null
var initTextureRectButtonB=null
var initTextureRectButtonC=null
var initTextureRectButtonD=null
var answerIsSubmited=false


var column_mapping= {
	"ID": "ID",
	"island": "subject",
	"title": "title",
	"text": "text"
}
var richt_text_bubble
var explanation_texts=[]
var explanatoin_text=null
func _read():

	var transparent_style = StyleBoxFlat.new()
	# Set the background color to fully transparent
	transparent_style.bg_color = Color(0, 0, 0, 0)
	richt_text_bubble=$explanation_text
func _pressed():
	richt_text_bubble.visible = !richt_text_bubble.visible


func _ready():
	print("hello")
	explanatoin_text=$explanation_text
	load_islands_names(Global.island_names_mapper_file_path)

	var explanations = load_json_file(Global.EXPLANATION_TEXTS_JSON_PATH)
	print(explanations)
	if explanations:
		for explanation in explanations:
			print("ID: ", explanation["ID"])
			print("Subject: ", explanation["subject"])
			print("Title: ", explanation["title"])
			print("Text: ", explanation["text"])
			print("----") # Separator for readability
	explanatoin_text.text=getTextOfExplanationOfIsland(Global.global_current_island)
	# Get the reference to the object to hide (RichTextLabel node)
	richt_text_bubble=$explanation_text
	$DoneButton.connect("pressed",Callable(self, "_on_DoneButton_pressed"))
	$Pause.connect("pressed",Callable(self, "_on_pause_pressed"))
	$BackToIslands.connect("pressed",Callable(self, "_on_back_to_islands_pressed"))

func find_elements_with_key(array, key):
	var result = null
	for element in array:
		if element['subject']== key:
			result=element
	return result
func _on_DoneButton_pressed():
	get_tree().change_scene_to_file(Global.currentLevelSceneTasks)
	

func reverseMap(dict):
	var reversed_dict = {}
	for key in dict.keys():
		var value = dict[key]
		reversed_dict[value] = key
	return reversed_dict

func getTextOfExplanationOfIsland(island):
	print("island_names_mapper: "+str(island_names_mapper))
	#var islandsNameReversedMap =reverseMap(island_names_mapper)

	var subject=island_names_mapper[island]
	print(subject)
	print(explanation_texts.find(subject))
	print(explanation_texts)
	var text=find_elements_with_key(explanation_texts,subject)['text']
	return text
	
func load_islands_names(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json = file.get_as_text()
		island_names_mapper = JSON.parse_string(json)
		file.close()
	else:
		print("island names mapper file not found!")
			
func _on_pause_pressed():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused 


func _on_back_to_islands_pressed():
	get_tree().change_scene_to_file("res://scenes/basic_islands_overview.tscn")


func load_json_file(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	#print(file_path)

	if file:
		var json_string = file.get_as_text()
		var json_result = JSON.parse_string(json_string)
		#print(json_result)
		explanation_texts=json_result
		return json_result

	else:
		print("Error opening file: ", file_path)
		return null


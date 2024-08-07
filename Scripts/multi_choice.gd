extends Node2D

@onready var pause_menu = $PauseMenu
var paused = false

var island_names_mapper_file_path = Global.island_names_mapper_file_path
var island_names_mapper = null


var column_mapping_file_path = "res://Scripts/jsonFiles/column_mapping.json"
var questions = []
var current_question = {}
var total_correct = 0
var asked_indices = []
var column_mapping = {}
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
var rightIcon = "res://resources/images/common/icons/right.svg"
var wrongIcon = "res://resources/images/common/icons/false.svg"
var texture_rect = null
var initTextureRectButtonA=null
var initTextureRectButtonB=null
var initTextureRectButtonC=null
var initTextureRectButtonD=null
var answerIsSubmited=false
func _ready():
	print("multi choice scene.")
	answerIsSubmited=false
	current_island = Global.global_current_island
	doneButton =  $Tasks/doneButton
	nextButton =  $Tasks/nextQuestion
	buttonAtexture=$Tasks/answers_box/Answer_A/TextureRect
	buttonBtexture=$Tasks/answers_box/Answer_B/TextureRect
	buttonCtexture=$Tasks/answers_box/Answer_C/TextureRect
	buttonDtexture=$Tasks/answers_box/Answer_D/TextureRect
	initTextureRectButtonA = buttonAtexture.texture
	initTextureRectButtonB = buttonBtexture.texture
	initTextureRectButtonC = buttonCtexture.texture
	initTextureRectButtonD = buttonDtexture.texture
	buttonA=$Tasks/answers_box/Answer_A
	buttonB=$Tasks/answers_box/Answer_B
	buttonC=$Tasks/answers_box/Answer_C
	buttonD=$Tasks/answers_box/Answer_D
	print(" current_island name:", current_island)

	# Seed the random number generator
	randomize()
	TranslationServer.set_locale("de")
		# Load islands-subject mapper tions from file
	load_islands_names(island_names_mapper_file_path)
	print(island_names_mapper)
	# Load column mappings from file
	load_column_mapping(column_mapping_file_path)
	print(column_mapping)
	# Load questions from file
	load_questions_from_file(Global.current_questions_file_path)
	print(column_mapping)
	nextButton.set_texture_normal(load(Global.nextButtonImagePath))
	# Connect the button press signal to the handler function,buttonBtexture
	#$Tasks/VBoxContainer/SubmitButton.connect("pressed", Callable(self, "_on_SubmitButton_pressed"))
	$Tasks/answers_box/Answer_A.connect("pressed",Callable(self,"_on_answer_button_pressed").bind($Tasks/answers_box/Answer_A/Answer,buttonAtexture))
	$Tasks/answers_box/Answer_B.connect("pressed",Callable(self,"_on_answer_button_pressed").bind($Tasks/answers_box/Answer_B/Answer,buttonBtexture))
	$Tasks/answers_box/Answer_C.connect("pressed",Callable(self,"_on_answer_button_pressed").bind($Tasks/answers_box/Answer_C/Answer,buttonCtexture))
	$Tasks/answers_box/Answer_D.connect("pressed",Callable(self,"_on_answer_button_pressed").bind($Tasks/answers_box/Answer_D/Answer,buttonDtexture))

	randomizeQuestions(Global.questoinsLimit)
	select_random_question()

	doneButton.connect("pressed",Callable(self, "_on_DoneButton_pressed"))
	nextButton.connect("pressed",Callable(self, "_on_nextButton_pressed"))
	
func _on_nextButton_pressed():
	select_random_question()
	answerIsSubmited=false
	nextButton.hide()
	
func randomizeQuestions(limitOfQuestions):
	print("limitOfQuestions: "+str(limitOfQuestions))
	filterQuestions.shuffle()
	filterQuestions=filterQuestions.slice(0,limitOfQuestions)
	
func _on_DoneButton_pressed():
	get_tree().change_scene_to_file("res://scenes/basic_islands_overview.tscn")

func load_islands_names(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json = file.get_as_text()
		island_names_mapper = JSON.parse_string(json)
		file.close()
	else:
		print("island names mapper file not found!")

func load_column_mapping(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json = file.get_as_text()
		column_mapping = JSON.parse_string(json)
		file.close()
	else:
		print("Column mapping file not found!")

func load_questions_from_file(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		#file.get_line()  # Skip header row
		var header = file.get_line().strip_edges().split(",")
		#print(header)
		while not file.eof_reached():
			var line = file.get_line()
			if line == "":
				continue
			var data = parse_csv_line(line)
			#print(data)
			print("header.find(column_mapping[question_text]):"+str(header.find(column_mapping["question_text"])))
			print("data:"+str(data))
			var question = {
				"ID": data[header.find(column_mapping["ID"])],
				"subject": data[header.find(column_mapping["subject"])],
				"title": data[header.find(column_mapping["title"])],
				"question_text": data[header.find(column_mapping["question_text"])],
				"options": data[header.find(column_mapping["options"])].substr(1, data[header.find(column_mapping["options"])].length() - 2).split(";"),
				"correct_answer": data[header.find(column_mapping["correct_answer"])]
			}

			questions.append(question)
			#print(question)

		file.close()
	else:
		print("Questions file not found!")
	filterQuestionList(questions)

func filterQuestionList(questionsList):
	for item in questionsList:
		if item.subject == island_names_mapper[current_island]:
			print(item.subject +"=="+current_island)
			filterQuestions.append(item)
	print(filterQuestions)
	
func parse_csv_line(line: String) -> Array:
	var result = []
	var current = ""
	var in_quotes = false
	var i = 0
	while i < line.length():
		var charachter = line[i]
		if charachter == '"' and (i == 0 or line[i - 1] != '\\'):
			if in_quotes and i + 1 < line.length() and line[i + 1] == '"':
			# Handle escaped quotes within quoted text
				current += '"'
				i += 1  # Skip the next quote
			else:
				in_quotes = not in_quotes
		elif charachter == ',' and not in_quotes:
			result.append(current.strip_edges())
			current = ""
		else:
			current += charachter
		i += 1
	result.append(current.strip_edges())
	return result

func select_random_question():
	buttonA.disabled =false
	buttonB.disabled =false
	buttonC.disabled =false
	buttonD.disabled =false
	buttonAtexture.texture=initTextureRectButtonA
	buttonBtexture.texture=initTextureRectButtonB
	buttonCtexture.texture=initTextureRectButtonC
	buttonDtexture.texture=initTextureRectButtonD
	if filterQuestions.size() > 0:
		if asked_indices.size() == filterQuestions.size():
			show_score()
			return

		var index = -1
		while index == -1 or index in asked_indices:
			index = randi() % filterQuestions.size()
		asked_indices.append(index)
		print("index:")
		print(index)
		current_question = filterQuestions[index]
		print(current_question)
		print("options:")
		print(current_question.options)
		$Tasks/title.text=current_question.title
		$"Tasks/VBoxContainer/Question-text".text=current_question.question_text
		$"Tasks/answers_box/Answer_A/Answer".text=current_question.options[0]
		$"Tasks/answers_box/Answer_B/Answer".text=current_question.options[1]
		$"Tasks/answers_box/Answer_C/Answer".text=current_question.options[2]
		$"Tasks/answers_box/Answer_D/Answer".text=current_question.options[3]
		$"Tasks/quesetion_size".text= str(asked_indices.size())+"/"+str(filterQuestions.size())
	else:
		$"Tasks/VBoxContainer/Question-text".text = "No questions available."
func _on_answer_button_pressed(button,textureRect):
	
	var answer = button.text
	print("Button text: "+answer)
	if(answerIsSubmited == false):
		submitAnswer(answer,textureRect)
	#button.texture =load(rightIcon)
	answerIsSubmited=true

func submitAnswer(user_answer,textureRect):

	var is_correct = check_answer(user_answer, current_question["correct_answer"])


	if is_correct:

		textureRect.texture=load(rightIcon)
		print("Correct!")

		total_correct += 1
	else:
		textureRect.texture=load(wrongIcon)
		print("Incorrect. The correct answer is: " + current_question["correct_answer"])
	nextButton.show()
	buttonA.disabled =true
	buttonB.disabled =true
	buttonC.disabled =true
	buttonD.disabled =true

func check_answer(user_answer, correct_answer):
	print("check_answer:user_answer '"+user_answer+"'")
	print("check_answer:correct_answer '"+correct_answer+"'")
	return user_answer.strip_edges().to_lower() == correct_answer.strip_edges().to_lower()


func show_score():
	var total_questions = filterQuestions.size()
	var score_text = "Du hast " + str(total_correct) + " von  " + str(total_questions) + " Fragen richtig beantwortet."
	$Tasks/show_score.text = score_text
	$Tasks/show_score.show()
	$"Tasks/VBoxContainer/Question-text".hide()
	$Tasks/answers_box.hide()
	$Tasks/title.hide()
	$Tasks/doneButton.show()
	var next_island=get_next_key(Global.basics_islands,current_island)
	if(total_correct==total_questions):
		Global.basics_islands[next_island]=true
	else:
		Global.basics_islands[next_island]=false
	var are_basics_island_finished=check_all_true(Global.basics_islands)
	print("are_basics_island_finished:")
	print(are_basics_island_finished)
	
	if(are_basics_island_finished and total_correct==total_questions):
		Global.eis=true
	else:
		Global.eis=false
	#$Tasks/doneButton.disabled=false
	#var doneButton = $Tasks/doneButton
	#doneButton.disabled = false
func get_next_key(map, current_key):
	var keys = map.keys()
	var current_index = keys.find(current_key)
	print("current_index")
	print(current_index)
	if current_index != -1 and current_index < keys.size() - 1:
		print("next Island key")
		print(keys[current_index + 1])
		return keys[current_index + 1]
	return null


func check_all_true(dict):
	for value in dict.values():
		if not value:
			return false
	return true




func _on_pause_pressed():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused 

func _on_back_to_islands_pressed():
	get_tree().change_scene_to_file("res://Scenes/basic_islands_overview.tscn")

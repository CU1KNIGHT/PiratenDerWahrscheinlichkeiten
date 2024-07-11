extends Node2D

@onready var pause_menu = $PauseMenu
var paused = false

#var island_names_mapper_file_path = "res://Scripts/jsonFiles/islandsMap.json"

var answers_file_path = "res://resources/Game-Task-and-Questions/Tasks/user_answers.csv1"
var column_mapping_file_path = "res://Scripts/jsonFiles/column_mapping.json"
var questions = []
var current_question = {}
var total_correct = 0
var asked_indices = []
var column_mapping = {}
var islands_subject_map = {}
var current_island = ""
var feedback=null
var nextButton=null
var answerInputField=null
var submitInputButton=null
var doneButton=null
var questionTextField=null
var questionTitle=null
var questionIndex=null
var inputBackground=null
var placeholder_text = "eingeben"

func _ready():

	feedback=$Tasks/feedback
	nextButton=$Tasks/nextQuestion
	answerInputField=$Tasks/inputBackground/AnswerInput
	submitInputButton=$Tasks/SubmitButton
	doneButton = $Tasks/doneButton
	questionTextField=$Tasks/VBoxContainer/questionText
	questionTitle=$Tasks/title
	questionIndex=$Tasks/questionIndex
	inputBackground=$Tasks/inputBackground

	current_island = get_tree().current_scene
	print(" current_island name:", current_island.name)
	
	doneButton.disabled = true
	# Seed the random number generator
	randomize()

	# Load column mappings from file
	load_column_mapping(column_mapping_file_path)

	# Load questions from file
	load_questions_from_file(Global.current_questions_file_path)

	# Load islands-subject mapper tions from file
	#load_islands_names(island_names_mapper_file_path)
	# Connect the button press signal to the handler function

	submitInputButton.connect("pressed", Callable(self, "_on_SubmitButton_pressed"))

	nextButton.set_texture_normal(load(Global.nextButtonImagePath))
	nextButton.connect("pressed", Callable(self, "get_next_question"))
	doneButton.connect("pressed", Callable(self, "_on_done_button_pressed"))
	$Pause.connect("pressed",Callable(self, "_on_pause_pressed"))
	$BackToIslands.connect("pressed",Callable(self, "_on_back_to_islands_pressed"))
	answerInputField.connect("focus_entered",Callable(self, "_on_focus_answer_input_entered"))
	answerInputField.connect("focus_exited",Callable(self, "_on_focus_answer_input_exited"))
	randomizeQuestions(Global.questoinsLimit)
	# Select and display the first question
	select_random_question()
	
func randomizeQuestions(limitOfQuestions):
	questions.shuffle()
	questions=questions.slice(0,limitOfQuestions)
	
func load_islands_names(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json = file.get_as_text()
		column_mapping = JSON.parse_string(json)
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
		print(header)
		while not file.eof_reached():
			var line = file.get_line()
			if line == "":
				continue
			var data = parse_csv_line(line)
			print(data)
			var question = {
				"ID": data[header.find(column_mapping["ID"])],
				"subject": data[header.find(column_mapping["subject"])],
				#
				"title": data[header.find(column_mapping["title"])],
				"question_text": data[header.find(column_mapping["question_text"])],
				#"options": data[header.find(column_mapping["options"])].substr(1, data[header.find(column_mapping["options"])].length() - 2).split("; "),
				"correct_answer": data[header.find(column_mapping["correct_answer"])].replace(",",".")
			}
			questions.append(question)
			print(question)

		file.close()
	else:
		print("Questions file not found!")
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
	feedback.hide()
	if questions.size() > 0:
		if asked_indices.size() == questions.size():
			show_score()
			return

		var index = -1
		while index == -1 or index in asked_indices:
			index = randi() % questions.size()
		asked_indices.append(index)
		print("index:")
		print(index)
		current_question = questions[index]
		#print(questions)
		print(current_question)
		#print(current_question)
		#print(index)
		questionIndex.text=str(asked_indices.size())+"/"+str(questions.size())
		questionTextField.text = current_question["question_text"]
		questionTitle.text=current_question["title"]
	else:
		questionTextField.text = "No questions available."

func _on_SubmitButton_pressed():
	var user_answer = replaceComma(answerInputField.text)
	print("user_anser is valid float: "+str(user_answer.is_valid_float()))
	user_answer=String.num(float(user_answer),2)
	print("user_answer: "+user_answer)
	var is_correct = check_answer(user_answer, current_question["correct_answer"])
	save_answer(current_question["ID"], current_question["question_text"], current_question["correct_answer"], user_answer, answers_file_path)
		
	if is_correct:
		print("Correct!")
		feedback.texture=load(Global.rightIcon)
		total_correct += 1
	else:
		feedback.texture=load(Global.wrongIcon)
		print("Incorrect. The correct answer is: " + current_question["correct_answer"])
	feedback.show()
	answerInputField.text = ""
	nextButton.show()
	answerInputField.editable=false
	#answerInputField.disable=true
	submitInputButton.disabled = true

func get_next_question():
	answerInputField.editable=true
	submitInputButton.disabled = false
	#answerInputField.disable=false
	feedback.hide()
	nextButton.hide()
	select_random_question()
	
func check_answer(user_answer, correct_answer):
	print("check answer: "+ user_answer)
	print("correct_answer"+ correct_answer)
	return user_answer.strip_edges().to_lower() == correct_answer.strip_edges().to_lower()

func save_answer(question_id: String, question_text: String, correct_answer: String, user_answer: String, file_path: String):
	var file: FileAccess
	if FileAccess.file_exists(file_path):
		file = FileAccess.open(file_path, FileAccess.WRITE_READ)
		file.seek_end()  # Move the file cursor to the end of the file
	else:
		file = FileAccess.open(file_path, FileAccess.WRITE)

	if file:
		var entry = question_id + "," + question_text + "," + correct_answer + "," + user_answer + "\n"
		file.store_string(entry)
		file.close()
	else:
		print("Failed to open file for writing.")

func show_score():
	var total_questions = questions.size()
	var score_text = "Du hast " + str(total_correct) + " von  " + str(total_questions) + " Fragen richtig beantwortet."
	if(Global.global_current_overview_scene_path==Global.LAVA_OVERVIEW_SCENE_PATH and total_questions==total_correct):
		Global.is_the_game_finshed=true
	else:
		Global.is_the_game_finshed=false
	#if(Global.Q2==Global.current_questions_file_path and total_correct==total_questions):
		#Global.lava=true
	#else:
		#Global.lava=false
	questionTextField.text = score_text
	answerInputField.hide()
	submitInputButton.hide()
	doneButton.disabled=false

	doneButton.disabled = false
	doneButton.visible =true
	answerInputField.hide()
	inputBackground.hide()
	questionTitle.hide()




func _on_done_button_pressed():

	get_tree().change_scene_to_file(Global.global_current_overview_scene_path)

func _on_pause_pressed():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0

	paused = !paused


func _on_back_to_islands_pressed():
	get_tree().change_scene_to_file(Global.global_current_overview_scene_path)

func _on_focus_answer_input_entered():
	# Clear the placeholder text when the LineEdit gains focus
	if answerInputField.text == "":
		if(answerInputField.editable):
			answerInputField.placeholder_text = ""

func _on_focus_answer_input_exited():
	# Restore the placeholder text if the LineEdit is empty
	if answerInputField.text == "":
		answerInputField.placeholder_text = placeholder_text
		
func replaceComma(new_text):
	var valid_text = ""
	for i in range(new_text.length()):
		var charachter = new_text[i]
		if charachter == ",":
			valid_text += "."
		elif charachter:
			valid_text += charachter
	return valid_text

extends Node2D

var island_names_mapper_file_path = "res://Scripts/jsonFiles/islandsMap.json"
var questions_file_path = "res://resources/Game-Task-and-Questions/Tasks/Q1.csv1"
var answers_file_path = "res://resources/Game-Task-and-Questions/Tasks/user_answers.csv1"
var column_mapping_file_path = "res://Scripts/jsonFiles/column_mapping.json"
var questions = []
var current_question = {}
var total_correct = 0
var asked_indices = []
var column_mapping = {}
var islands_subject_map = {}
var current_island = "Grundlage-Wahrscheinlichkeiten"
var filterQuestions=[] 

func _ready():
	current_island = Global.global_current_island
	
	print(" current_island name:", current_island)
	var doneButton = $Tasks/doneButton

	# Seed the random number generator
	randomize()
	TranslationServer.set_locale("de")
	# Load column mappings from file
	load_column_mapping(column_mapping_file_path)

	# Load questions from file
	load_questions_from_file(questions_file_path)

	# Load islands-subject mapper tions from file
	load_islands_names(island_names_mapper_file_path)
	# Connect the button press signal to the handler function
	#$Tasks/VBoxContainer/SubmitButton.connect("pressed", Callable(self, "_on_SubmitButton_pressed"))
	$Tasks/answers_box/Answer_A.connect("pressed",Callable(self,"_on_answer_button_pressed").bind($Tasks/answers_box/Answer_A/Answer))
	$Tasks/answers_box/Answer_B.connect("pressed",Callable(self,"_on_answer_button_pressed").bind($Tasks/answers_box/Answer_B/Answer))
	$Tasks/answers_box/Answer_C.connect("pressed",Callable(self,"_on_answer_button_pressed").bind($Tasks/answers_box/Answer_C/Answer))
	$Tasks/answers_box/Answer_D.connect("pressed",Callable(self,"_on_answer_button_pressed").bind($Tasks/answers_box/Answer_D/Answer))
	# Select and display the first question
	select_random_question()

	doneButton.connect("pressed",Callable(self, "_on_DoneButton_pressed"))
	
func _on_DoneButton_pressed():
	get_tree().change_scene_to_file("res://scenes/basic_islands_overview.tscn")

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
			var data = parse_csv_line(line)
			print(data)
			var question = {
				"ID": data[header.find(column_mapping["ID"])],
				"subject": data[header.find(column_mapping["subject"])],
				"title": data[header.find(column_mapping["title"])],
				"question_text": data[header.find(column_mapping["question_text"])],
				"options": data[header.find(column_mapping["options"])].substr(1, data[header.find(column_mapping["options"])].length() - 2).split(";"),
				"correct_answer": data[header.find(column_mapping["correct_answer"])]
			}

			questions.append(question)
			print(question)

		file.close()
	else:
		print("Questions file not found!")
	for item in questions:
		if item.subject == current_island:
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
func _on_answer_button_pressed(button):


	var answer = button.text
	print("Button text: "+answer)
	submitAnswer(answer)

func submitAnswer(user_answer):

	var is_correct = check_answer(user_answer, current_question["correct_answer"])
	save_answer(current_question["ID"], current_question["question_text"], current_question["correct_answer"], user_answer, answers_file_path)

	if is_correct:
		print("Correct!")
		total_correct += 1
	else:
		print("Incorrect. The correct answer is: " + current_question["correct_answer"])

	#$Tasks/VBoxContainer/AnswerInput.text = ""
	select_random_question()

func check_answer(user_answer, correct_answer):
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
	var total_questions = filterQuestions.size()
	var score_text = "You answered " + str(total_correct) + " out of " + str(total_questions) + " questions correctly."
	$Tasks/show_score.text = score_text
	$Tasks/show_score.show()
	$"Tasks/VBoxContainer/Question-text".hide()
	$Tasks/answers_box.hide()
	$Tasks/title.hide()
	$Tasks/doneButton.show()
	
	#$Tasks/doneButton.disabled=false
	#var doneButton = $Tasks/doneButton
	#doneButton.disabled = false







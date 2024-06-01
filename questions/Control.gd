extends Node2D

var questions_file_path = "res://Q3.csv"
var answers_file_path = "res://user_answers.csv"
var column_mapping_file_path = "res://column_mapping.json"
var questions = []
var current_question = {}
var total_correct = 0
var asked_indices = []
var column_mapping = {}

func _ready():
	# Seed the random number generator
	randomize()

	# Load column mappings from file
	load_column_mapping(column_mapping_file_path)
	
	# Load questions from file
	load_questions_from_file(questions_file_path)
	
	# Connect the button press signal to the handler function
	$Control/VBoxContainer/SubmitButton.connect("pressed", Callable(self, "_on_SubmitButton_pressed"))
	
	# Select and display the first question
	select_random_question()
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
				#
				"title": data[header.find(column_mapping["title"])],
				"question_text": data[header.find(column_mapping["question_text"])],
				#"question_text": data[3],
				"options": data[header.find(column_mapping["options"])].substr(1, data[header.find(column_mapping["options"])].length() - 2).split("; "),
				"correct_answer": data[header.find(column_mapping["correct_answer"])]
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
		var char = line[i]
		if char == '"' and (i == 0 or line[i - 1] != '\\'):
			if in_quotes and i + 1 < line.length() and line[i + 1] == '"':
			# Handle escaped quotes within quoted text
				current += '"'
				i += 1  # Skip the next quote
			else:
				in_quotes = not in_quotes
		elif char == ',' and not in_quotes:
			result.append(current.strip_edges())
			current = ""
		else:
			current += char
		i += 1
	result.append(current.strip_edges())
	return result

func select_random_question():
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
		
		$Control/VBoxContainer/QuestionLabel1.text = current_question["question_text"]
	else:
		$Control/VBoxContainer/QuestionLabel1.text = "No questions available."

func _on_SubmitButton_pressed():
	var user_answer = $Control/VBoxContainer/AnswerInput.text
	var is_correct = check_answer(user_answer, current_question["correct_answer"])
	save_answer(current_question["ID"], current_question["question_text"], current_question["correct_answer"], user_answer, answers_file_path)

	if is_correct:
		print("Correct!")
		total_correct += 1
	else:
		print("Incorrect. The correct answer is: " + current_question["correct_answer"])

	$Control/VBoxContainer/AnswerInput.text = ""
	select_random_question()

func check_answer(user_answer, correct_answer):
	return user_answer.strip_edges().to_lower() == correct_answer.strip_edges().to_lower()

func save_answer(question_id, question_text, correct_answer, user_answer, file_path):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		var existing_content = ""
		if FileAccess.file_exists(file_path):
			existing_content = FileAccess.open(file_path, FileAccess.READ).get_as_text()

		file.store_string(existing_content + question_id + "," + question_text + "," + correct_answer + "," + user_answer + "\n")
		file.close()
	else:
		print("Failed to open file for writing.")
		
func show_score():
	var total_questions = questions.size()
	var score_text = "You answered " + str(total_correct) + " out of " + str(total_questions) + " questions correctly."
	#$Control/VBoxContainer/QuestionLabel1.text = score_text
	$Control/VBoxContainer/AnswerInput.hide()
	$Control/VBoxContainer/SubmitButton.hide()



func _on_quit_button_button_down():
	get_tree().quit()  
	# if user wants turn to main game scene
	# get_tree().change_scene("res://path_to_your_scene.tscn")

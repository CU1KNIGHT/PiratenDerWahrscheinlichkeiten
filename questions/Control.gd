extends Node2D

var questions_file_path = "res://questions.csv"
var answers_file_path = "res://user_answers.csv"
var questions = []
var current_question = {}
var total_correct = 0
var asked_indices = []

func _ready():
	# Seed the random number generator
	randomize()

	# Load questions from file
	load_questions_from_file(questions_file_path)
	
	# Connect the button press signal to the handler function
	$Control/VBoxContainer/SubmitButton.connect("pressed", Callable(self, "_on_SubmitButton_pressed"))
	
	# Select and display the first question
	select_random_question()

func load_questions_from_file(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		file.get_line()  # Skip header row
		while not file.eof_reached():
			var line = file.get_line()
			var data = line.split(",")
			var question = {
				"id": data[0],
				"question_text": data[1],
				"correct_answer": data[2]
			}
			questions.append(question)
		file.close()
	else:
		print("Questions file not found!")

func select_random_question():
	if questions.size() > 0:
		if asked_indices.size() == questions.size():
			show_score()
			return
			
		var index = -1
		while index == -1 or index in asked_indices:
			index = randi() % questions.size()
		asked_indices.append(index)
		current_question = questions[index]
		$Control/VBoxContainer/QuestionLabel1.text = current_question["question_text"]
	else:
		$Control/VBoxContainer/QuestionLabel1.text = "No questions available."

func _on_SubmitButton_pressed():
	var user_answer = $Control/VBoxContainer/AnswerInput.text
	var is_correct = check_answer(user_answer, current_question["correct_answer"])
	save_answer(current_question["id"], current_question["question_text"], current_question["correct_answer"], user_answer, answers_file_path)

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
	$Control/VBoxContainer/QuestionLabel1.text = score_text
	$Control/VBoxContainer/AnswerInput.hide()
	$Control/VBoxContainer/SubmitButton.hide()


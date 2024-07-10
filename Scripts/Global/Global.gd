extends Node

# Define your global variables here
#from subject column in csv files
const Q3="res://resources/Game-Task-and-Questions/Tasks/Q3.csv1"
const Q2="res://resources/Game-Task-and-Questions/Tasks/Q2.csv1"
const island_names_mapper_file_path="res://Scripts/jsonFiles/islandsMap.json"
const EXPLANATION_TEXTS_JSON_PATH="res://resources/json/islands_explanation.json"
var current_questions_file_path = Q2
const EIS_OVERVIEW_SCENE_PATH="res://Scenes/ice_islands_overview.tscn"
const LAVA_OVERVIEW_SCENE_PATH="res://Scenes/lava_islands_overview.tscn"

const EXPLANATION_SCENE_PATH="res://Scenes/explanation.tscn"
const MULTICHOICE_BASICS_SCENE_PATH="res://Scenes/grundlage/TasksMulti-choice.tscn"
const MULTICHOICE_EIS_SCENE_PATH="res://Scenes/TasksMulti-choice-Eis.tscn"
const INPUT_FIELD_TASKS_LAVAL_SCENE_PATH="res://Scenes/Tasks.tscn"
var currentLevelSceneTasks="res://Scenes/grundlage/TasksMulti-choice.tscn"
#as subject in Q1.csv1
var global_current_island="wahrschinx-island"
var global_current_overview_scene_path=EIS_OVERVIEW_SCENE_PATH
var is_the_game_finshed=false
#show Islands
var basics = true
var eis = false
var lava = false
var basics_islands = {
	"wahrschinx-island": true,
	"ereignisse-island": false,
	"gegenereignis-island": false,
	"lapalce-island": false,
	"zufallexperiment-island": false
}
#buttons src path
var rightIcon = "res://resources/Game UI Design/icons/right.svg"
var wrongIcon = "res://resources/Game UI Design/icons/false.svg"
var nextButtonImagePath="res://resources/images/next.png"
#limits
var questoinsLimit=2

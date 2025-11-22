class_name GameOver extends Control
var score:float
var time:float
var distance:float

@onready var score_label:Label = find_child("Score")
@onready var time_label:Label = find_child("Time")
@onready var distance_label:Label = find_child("Distance")

@onready var try_again:Button = find_child("TryAgain")
@onready var quit:Button = find_child("Quit")
@onready var main_menu:Button = find_child("MainMenu")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_label.text = "%.02f" % score
	time_label.text = "%02d:%02d" % [time/60, int(time) % 60]
	distance_label.text = "%.02f meters" % distance
	try_again.pressed.connect(func():
		SceneManager.set_scene(SceneManager.scenes.get('gameplay'))
	)
	quit.pressed.connect(func():
		get_tree().quit()
	)
	main_menu.pressed.connect(func():
		SceneManager.set_scene(SceneManager.scenes.get('main_menu'))
	)
	if OS.has_feature("web"):
		quit.hide()

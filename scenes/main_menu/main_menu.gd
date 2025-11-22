extends Control

func _ready():
	MusicManager.play(&"main_menu")

func _on_start_pressed():
	$CutScenes.play("Loading")
	await $CutScenes.animation_finished
	SceneManager.set_scene(SceneManager.scenes.get('gameplay'))


func _on_options_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()

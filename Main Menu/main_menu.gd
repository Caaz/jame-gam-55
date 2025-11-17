extends Control

func _on_start_pressed():
	$CutScenes.play("Loading")
	await $CutScenes.animation_finished
	get_tree().change_scene_to_file("res://scenes/testbed/testbed.tscn")


func _on_options_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()

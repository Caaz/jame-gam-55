extends Node

func _ready() -> void:
	SceneManager.set_scene(SceneManager.scenes.get('main_menu'))

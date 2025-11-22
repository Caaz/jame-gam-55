extends Node
var scenes:Dictionary[String, PackedScene]
const SCENES:ResourceGroup = preload("uid://dnbe6e26w50mx")

@onready var scene_container:Node = get_tree().get_first_node_in_group(&"scene_container")

func set_scene(scene:PackedScene):
	set_node(scene.instantiate())

func set_node(node:Node):
	_clear()
	scene_container.add_child(node)

## Clears existing scene
func _clear() -> void:
	if scene_container.get_child_count() == 0:
		return
	var child:Node = scene_container.get_child(0)
	child.queue_free()

func _ready() -> void:
	var raw_scenes:Array = SCENES.load_all()
	for raw_scene:PackedScene in raw_scenes:
		var path:String = raw_scene.resource_path
		var file_name:String = path.split("/")[-1].rstrip(".tscn")
		scenes[file_name] = raw_scene

extends Node
@onready var music_player:AudioStreamPlayer = get_tree().get_first_node_in_group("music_player")

func play(track:StringName) -> void:
	music_player.set("parameters/switch_to_clip", track)

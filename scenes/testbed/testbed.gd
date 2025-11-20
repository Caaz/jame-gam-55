extends Node3D
@onready var player = $osprey
@onready var level_builder:LevelBuilder = find_child("LevelBuilder")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Label.text = "%.f" % [player.position.z / 10]
	level_builder.target_cell = int(player.position.z / level_builder.cell_size.z)

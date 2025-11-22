extends Node3D
signal game_over(score:float)
@onready var player = $osprey
@onready var level_builder:LevelBuilder = find_child("LevelBuilder")
@onready var score_label:Label = find_child("ScoreLabel")
@onready var speed_display_shader:ShaderMaterial = find_child("SpeedDisplay").material as ShaderMaterial
@onready var speed_distortion_shader:ShaderMaterial = find_child("SpeedEffect").material as ShaderMaterial
var score:float:
	get:
		return player.position.z / 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.crashed.connect(func():
		game_over.emit(score)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	score_label.text = "%.2f" % score
	level_builder.target_cell = int(player.position.z / level_builder.cell_size.z)
	speed_display_shader.set_shader_parameter("percent", player.speed_percentage)
	speed_distortion_shader.set_shader_parameter("effect_power", pow(player.speed_percentage,2))

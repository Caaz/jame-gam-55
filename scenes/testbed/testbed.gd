extends Node3D
signal game_over(score:float)
@onready var player = $osprey
@onready var level_builder:LevelBuilder = find_child("LevelBuilder")
@onready var score_label:Label = find_child("ScoreLabel")
@onready var speed_label:Label = find_child("SpeedLabel")
@onready var time_label:Label = find_child("TimeLabel")
@onready var speed_display_shader:ShaderMaterial = find_child("SpeedDisplay").material as ShaderMaterial
@onready var speed_distortion_shader:ShaderMaterial = find_child("SpeedEffect").material as ShaderMaterial
var score:float:
	get:
		return max(0, player.position.z / (player.TOP_SPEED  / 2.) - ghost_score)

var ghost_score:float:
	get:
		var expected_distance:float = gameplay_time * player.TOP_SPEED / 4.
		return expected_distance / (player.TOP_SPEED / 2.)
	
var gameplay_time:float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameplay_time = 0
	player.crashed.connect(func():
		game_over.emit(score)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	gameplay_time += delta
	score_label.text = "%.02f" % score
	level_builder.target_cell = int(player.position.z / level_builder.cell_size.z)
	var speed:float = player.speed_percentage
	speed_display_shader.set_shader_parameter("percent", speed)
	speed_distortion_shader.set_shader_parameter("effect_power", pow(speed, 2))
	speed_label.text = "%d" % (speed * 100)
	time_label.text = "%02d:%02d" % [gameplay_time / 60., int(gameplay_time) % 60]

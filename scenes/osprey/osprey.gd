class_name Player extends CharacterBody3D
const FLAP_STRENGTH:float = 1000
const ROLL_SPEED:float = 3
const PITCH_SPEED:float = 4
const GRAVITY_STRENGTH: float = 1
const FLIGHT_SPEED:float = 1
const GLIDE_STRENGTH:float = 15
const TOP_SPEED:float = 60
const LIFT_FACTOR:float = 10
const DRAG_FACTOR:float = 40
var target_angle:Vector2
@onready var model:Node3D = find_child("Armature")
@onready var animation_player:AnimationPlayer = find_child("AnimationPlayer")
@onready var animation_tree:AnimationTree = find_child("AnimationTree")
@onready var state_machine:AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

var can_flap:bool:
	get:
		return state_machine.get_current_node() != &"flap"

func _physics_process(delta: float) -> void: 
	velocity += get_gravity() * delta * GRAVITY_STRENGTH
	if Input.is_action_just_pressed("flap") and can_flap:
		state_machine.travel("flap")
		await create_tween().tween_interval(.4).finished
		velocity += model.basis.y * FLAP_STRENGTH * delta
		velocity += model.basis.z * FLAP_STRENGTH * delta
		return
	
	var input_dir := Input.get_vector("roll_left", "roll_right",  "pitch_up", "pitch_down")
	target_angle.x = move_toward(target_angle.x, input_dir.x, delta * ROLL_SPEED * (abs(input_dir.x - target_angle.x)))
	target_angle.y = move_toward(target_angle.y, input_dir.y, delta * PITCH_SPEED * (abs(input_dir.y - target_angle.y))) 
	var roll:float = target_angle.x * -PI/2
	var pitch:float = target_angle.y * PI/2
	animation_tree.set("parameters/glide/blend_position", -target_angle.y)
	
	model.transform.basis = basis.rotated(Vector3.FORWARD, roll) * basis.rotated(Vector3.RIGHT, pitch )
	
	var forward_speed:float = (velocity * model.basis.z).z
	var speed_percentage:float = (forward_speed / TOP_SPEED)
	if speed_percentage > 0:
		velocity = velocity.move_toward(model.basis.z * velocity.length(), abs(velocity.dot(model.basis.y)) * delta * 2.5 * (speed_percentage))
	
	if velocity.length() > TOP_SPEED:
		velocity = velocity.normalized() * TOP_SPEED
		
	
	move_and_slide()
	RenderingServer.global_shader_parameter_set("player_position", global_position)

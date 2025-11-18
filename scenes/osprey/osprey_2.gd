extends CharacterBody3D
const FLAP_STRENGTH:float = 1000
const ROLL_SPEED:float = 2
const PITCH_SPEED:float = 2
const GRAVITY_STRENGTH: float = 1
const FLIGHT_SPEED:float = 1
const GLIDE_STRENGTH:float = 3
const TOP_SPEED:float = 40
var target_angle:Vector2
@onready var model:Node3D = find_child("Armature")
@onready var animation_player:AnimationPlayer = find_child("AnimationPlayer")
var can_flap:bool:
	get:
		return animation_player.current_animation != &"flap"

func _ready() -> void:
	animation_player.play(&'glide')
	animation_player.animation_finished.connect(func(animation_name:StringName) -> void:
		if animation_name == &'flap':
			animation_player.play(&'glide')
	)
func _physics_process(delta: float) -> void: 
	velocity += get_gravity() * delta * GRAVITY_STRENGTH
	if Input.is_action_just_pressed("flap") and can_flap:
		animation_player.play(&'flap')
		await create_tween().tween_interval(.4).finished
		velocity += model.basis.y * FLAP_STRENGTH * delta
		return
	
	var input_dir := Input.get_vector("roll_left", "roll_right",  "pitch_up", "pitch_down")
	target_angle.x = move_toward(target_angle.x, input_dir.x, delta * ROLL_SPEED * (abs(input_dir.x - target_angle.x)))
	target_angle.y = move_toward(target_angle.y, input_dir.y, delta * PITCH_SPEED * (abs(input_dir.y - target_angle.y)))
	var roll:float = target_angle.x * -PI/2
	var pitch:float = target_angle.y * PI/2.5
	print(target_angle.y )
	if target_angle.y > .7 and animation_player.current_animation == &'glide':
		animation_player.play(&'dive')
	elif target_angle.y < .4 and animation_player.current_animation == &'dive':
		animation_player.play(&'glide')
	model.transform.basis = basis.rotated(Vector3.FORWARD, roll)* basis.rotated(Vector3.RIGHT, pitch)
	velocity += model.basis.z * FLIGHT_SPEED * delta
	velocity += model.basis.y * GLIDE_STRENGTH * delta
	
	
	var vertical_velocity:Vector3 = velocity * model.basis.y
	if vertical_velocity.y < 0:
		velocity += model.basis.z * -vertical_velocity.y * delta * 5
	else:
		velocity = velocity.move_toward(velocity * model.basis.y * .7, delta * GLIDE_STRENGTH)
	if velocity.length() > TOP_SPEED:
		velocity = velocity.normalized() * TOP_SPEED
	move_and_slide()
	#velocity.move_toward(Vector3.ZERO, delta)

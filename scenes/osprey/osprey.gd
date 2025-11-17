class_name Player extends CharacterBody3D
@onready var model:Node3D = find_child("Armature")
@onready var animation_player:AnimationPlayer = find_child("AnimationPlayer")
const X_ACCELLERATION:float = 200.0
const Y_ACCELLERATION:float = 200.0
const FORWARD_SPEED:float = 2000
const Y_DAMPENING:float = 25.0
const X_DAMPENING:float = 75.0

const TOP_X_SPEED:float = 30
const TOP_Y_SPEED_POS:float = 30
const TOP_Y_SPEED_NEG:float = 100
func _ready() -> void:
	animation_player.play('flap')

func _physics_process(delta: float) -> void:

	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right",  "ui_up", "ui_down")
	velocity += model.basis.y * input_dir.y * delta * Y_ACCELLERATION
	velocity.x += -input_dir.x * delta * X_ACCELLERATION
	
	
	velocity.x = clamp(velocity.x, -TOP_X_SPEED, TOP_X_SPEED)
	#velocity.y = clamp(velocity.y, -TOP_Y_SPEED_NEG, TOP_Y_SPEED_POS)
	
	
	velocity.z = delta * FORWARD_SPEED
	#model.rotation.z = velocity.x
	var roll:float = velocity.x / TOP_X_SPEED * PI/3
	var pitch:float = velocity.y / TOP_Y_SPEED_POS * -PI/5
	model.transform.basis = basis.rotated(Vector3.RIGHT, pitch) * basis.rotated(Vector3.FORWARD, roll)

	move_and_slide()

	velocity.y = move_toward(velocity.y, 0, delta * Y_DAMPENING)
	velocity.x = move_toward(velocity.x, 0, delta * X_DAMPENING)

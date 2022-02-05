extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
const MAX_VELOCITY = 300
const ACCELERATION = 500
const FRICTION = 50

var velocity = Vector2.ZERO

enum{
	MOVE,
	ROLL,
	ATTACK,
}
var state = MOVE
#_physics_process
func _process(delta):
	match state:
		MOVE: move_state(delta)
		ATTACK: attack_state(delta)
		ROLL: roll_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") -  Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_VELOCITY, ACCELERATION * delta)
		print(input_vector)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	
func attack_state(delta):
	pass
	

func roll_state(delta):
	pass

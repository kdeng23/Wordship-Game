extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

onready var stats = $Stats
export var MAX_VELOCITY = 100
export var ACCELERATION = 500
export var FRICTION = 50

var velocity = Vector2.ZERO
const bulletPath = preload("res://Player/shots.tscn")
#var rotation_speed = 1.5

enum{
	MOVE,
	DASH,
	ATTACK,
}
var state = MOVE
#_physics_process
func _process(delta):
	$Node2D.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("attack"):
		shoot()
		
	match state:
		MOVE: move_state(delta)
		ATTACK: attack_state(delta)
		DASH: dash_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") -  Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	#look_at(get_global_mouse_position())
	rotation = get_global_mouse_position().angle_to_point(position)
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_VELOCITY, ACCELERATION * delta)
		#print(input_vector)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	
func attack_state(delta):
	pass
	

func dash_state(delta):
	pass

func shoot():
	var bullet = bulletPath.instance()
	get_parent().add_child(bullet)
	bullet.position = $Node2D/Position2D.global_position
	bullet.velocity = get_global_mouse_position() - bullet.position

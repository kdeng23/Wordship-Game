extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2.ZERO
var speed = 300
onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()
	$LaserSound.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = get_global_mouse_position().angle_to_point(position)
	var collision_info = move_and_collide(velocity.normalized()*delta*speed)

func _on_Timer_timeout():
	queue_free()

func _on_HurtBox_area_entered(area):
	queue_free()

extends KinematicBody2D

func addWord(word):
	$TheWord.set_bbcode(word)

#const bulletPath = preload("res://Player/shots.tscn")
onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftCollision
enum{
	IDLE,
	WANDER,
	CHASE,
}

var state = IDLE
var velocity = Vector2.ZERO
var lunging = false
export var MAX_SPEED = 50
export var ACCELERATION = 500
export var FRICTION = 200

func _ready():
	pass # Replace with function body.

func _process(delta):
#	shoot()
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			#Sprite.flip_h = velocity.x < 0
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)
	if !lunging:
		_lunge()

func seek_player():
	#print('checking for player')
	if playerDetectionZone.can_see_player():
		#print('sees player')
		state = CHASE
	else:
		state = IDLE

func _on_HitBox_area_entered(area):
	print('collide')
	var word = $TheWord.bbcode_text
	var WordExplosion = load("res://Explosions/WordExplosion.tscn")
	var wordExplosion = WordExplosion.instance()
	var scene = get_tree().current_scene
	scene.add_child(wordExplosion)
	wordExplosion.global_position = global_position
	queue_free()
	var world = get_node("/root/World")
	world.guessWord(word)
	return word

func _lunge():
	lunging = true
	yield(get_tree().create_timer(5), "timeout") # How often the thing lunges
	ACCELERATION = 10000
	MAX_SPEED = 300
	FRICTION = 20
	yield(get_tree().create_timer(0.3), "timeout") # The lunge duration
	lunging = false
	MAX_SPEED = 50
	ACCELERATION = 500
	FRICTION = 200

#func shoot():
#	var bullet = bulletPath.instance()
#	get_parent().add_child(bullet)
#	bullet.position = $TestPos1.global_position
#	bullet.velocity = $TestPos2.global_position - bullet.position

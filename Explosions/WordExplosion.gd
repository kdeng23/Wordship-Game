extends Node2D


onready var animatedSprite = $AnimatedSprite
func _ready():
	animatedSprite.frame = 0
	animatedSprite.play("Animate")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimatedSprite_animation_finished():
	queue_free()
	pass

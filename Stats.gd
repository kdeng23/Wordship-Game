extends Node

export(int) var max_health = 1
onready var health = max_health setget set_health
onready var healthbar = $CanvasLayer/Label

signal no_health

func set_health(value):
	health = value
	if(health == 4):
		healthbar.clear()
		healthbar.add_text("DAMAGED")
	elif(health == 1):
		healthbar.clear()
		healthbar.add_text("GONNA EXPLODE")
	if health <= 0:
		healthbar.clear()
		healthbar.add_text("DEAD")
		emit_signal("no_health")


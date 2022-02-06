extends Node2D

var enemy = preload("res://Enemies/Word.tscn")
 

func _process(delta):
	pass

func spawn_enemy(word):
	var yLoc = rand_range(0,32)
	var xLoc = rand_range(0,570)
	var e = enemy.instance()
	e.addWord("[center]" + word + "[/center]")
	add_child(e)
	e.position = Vector2(xLoc, yLoc)
	$SpawnSound.play()


func _on_SpawnTime_timeout():
	var yLoc = rand_range(0,29)
	var xLoc = rand_range(0,570)
	var e = enemy.instance()
	e.addWord("Godot")
	add_child(e)
	e.position = Vector2(xLoc, yLoc)

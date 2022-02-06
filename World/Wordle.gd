extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var win = false

func addWord(word):
	var wordle = get_node("CanvasLayer")
	for child in wordle.get_children():
		if child is RichTextLabel:
			if child.bbcode_text == "":
				child.set_bbcode(word)
				break
	# Check to see if the player has run out of guesses
	for child in wordle.get_children():
		if child is RichTextLabel:
			if child.bbcode_text == "":
				return
	# Kill the player otherwise since all slots have been filled
	var player = get_node("/root/World/Player")
	player.killPlayer()
	var world = get_node("/root/World")
	world.handlePlayerLoss()
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
#	for _i in self.get_children():
#		print(_i.bbcode_text)
#		_i.set_bbcode("Hello")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

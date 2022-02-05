extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func addWord(word):
	for _i in self.get_children():
		print(_i.bbcode_text)
		if _i.bbcode_text == "":
			_i.set_bbcode(word)
			return

# Called when the node enters the scene tree for the first time.
func _ready():
#	for _i in self.get_children():
#		print(_i.bbcode_text)
#		_i.set_bbcode("Hello")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

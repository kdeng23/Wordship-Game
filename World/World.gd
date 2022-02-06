extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var websocket_url = "http://localhost:5000"

var _client = WebSocketClient.new()

func _ready():
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")

	# Initiate connection to the given URL.
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)
	startWordle()
#	guessWord("PLEAT")
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.

func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var backendData = _client.get_peer(1).get_packet().get_string_from_utf8() # this consumes the data and you can't get it back by calling the same method again
	print("Got data from server: ", backendData)
	var parsed = JSON.parse(backendData)
	if parsed.error == OK:
		var data = parsed.result.data
		var event = parsed.result.event
		print("Event: ", event)
		print("Data: ", data)
		if event == "spawnWord":
			_spawnWord(data)
		elif event == "guessResult":
			_guessResult(data)
		elif event == "hotWord":
			_handleHotword(data)
		elif event == "victory":
			_triggerVictory()
		else:
			print("Unknown event: ", event)
			print("The unknown event's data is: ", data)
	else:
		print("error in parsing JSON")
		print(parsed.error_string)
		print(parsed.error)
		print(parsed.error_line)

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()

func _spawnWord(word):
	# Spawn the fake word in the game
	print("Spawning ", word)
#	_guessResult(word)
	
func _guessResult(word):
	# populate the in-game wordle with the result
	print("Guessed ", word)
	
	# Find the Wordle game node
	var wordle = get_node("CanvasLayer/Wordle")
	
	# Call the addWord function
	wordle.addWord(word)
	
func _handleHotword(word):
	# Spawn or set the hot word the player needs to kill to win
	print("Hot Word is ", word)
	
func _triggerVictory():
	print("Player has won!")

func formatEvent(event, data):
	var genericJSONguess = "{\"event\":\"{event}\",\"data\":\"{data}\"}"
	return genericJSONguess.format({"event": event, "data": data})
	

func guessWord(word):
	# Send the word the player killed to the backend
	print(word)
	var formatted = formatEvent("guess", word)

	_client.get_peer(1).put_packet(formatted.to_utf8())

func startWordle():
	# Reset the Hot Word
	var formatted = formatEvent("startGame", 1)

	_client.get_peer(1).put_packet(formatted.to_utf8())
	
#	guessWord("TREAT")

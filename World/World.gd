extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var websocket_url = "http://localhost:3000"

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
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
#	_client.get_peer(1).put_packet("Test packet".to_utf8())
#	_client.get_peer(1).put_packet("test".to_utf8()) # this is how you send stuff

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
		else:
			print("Unknown event: ", event)
			print("The unknown event's data is: ", data)
	else:
		print("error in parsing JSON")
		print(parsed.error_string)
		print(parsed.error)
		print(parsed.error_line)
	
#	print("Got data from server: ", _client.get_peer(1).get_packet().get_string_from_utf8())
#	var result = JSON.parse(_client.get_peer(1).get_packet().get_string_from_utf8())
#	if result.error == OK:
#		print(result)
#	else:
#		print("error")
#		print(result.error_string)
#		print(result.error)
#		print(result.error_line)

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()

func _spawnWord(word):
	# Spawn the fake word in the game
	print("Spawning ", word)
	
func _guessResult(word):
	# populate the in-game wordle with the result
	print("Guessed ", word)
	
	# Find the Wordle game node
	var wordle = get_node("Wordle")
	
	# Call the addWord function
	wordle.addWord(word)
	

func _handleHotword(word):
	# Spawn or set the hot word the player needs to kill to win
	print("Hot Word is ", word)

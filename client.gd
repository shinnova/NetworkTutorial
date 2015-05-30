
extends Node

const port = 1250
var ip

var debug # kind of own debug console 

var connection # your connection (StreamPeerTCP) object
var peerstream # your data transfer (PacketPeerStream) object
var connected = false # for additional connection check


func _ready():
	debug = get_node("Debug")
	connection=StreamPeerTCP.new()
	connection.connect(ip,port) #inherits constants from StreamPeerTCP
	peerstream=PacketPeerStream.new()
	peerstream.set_stream_peer(connection)
	set_process(true)
		
func _process(delta):
	if !connected: #if last time the status was STATUS_CONNECTING
		if connection.get_status()==connection.STATUS_CONNECTED:
			debug.add_text("Connected to "+ip+":"+str(port));debug.newline()
			connected=true
		elif connection.get_status()==connection.STATUS_CONNECTING:
			debug.add_text("Trying to connect to "+ip+":"+str(port));debug.newline()
		elif connection.get_status()==connection.STATUS_NONE or connection.get_status()==connection.STATUS_ERROR:
			debug.add_text("Failed to connect to "+ip+":"+str(port));debug.newline()
	if connection.get_status()==connection.STATUS_NONE or connection.get_status()==connection.STATUS_ERROR:
		debug.add_text("Server disconnected?")
		set_process(false)
	peerstream.get_available_packet_count()


func _on_Button_Back_pressed():
	if connection:
		connection.disconnect()
	get_node("../Menu").show()
	queue_free() # remove yourself at idle frame
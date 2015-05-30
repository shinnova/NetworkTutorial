
extends Node

const port = 1250
var debug # kind of own debug console 

var server # for holding your TCP_Server object
var connection = [] # for holding multiple connection (StreamPeerTCP) objects
var peerstream = [] # for holding multiple data transfer (PacketPeerStream) objects

func _ready():
	debug = get_node("Debug")
	server=TCP_Server.new()
	
	if server.listen(port)==0:
		debug.add_text("Server started on port "+str(port));debug.newline()
		set_process(true)
	else:
		debug.add_text("Failed to start server on port "+str(port));debug.newline()
		
func _process(delta):
	if server.is_connection_available(): #someone connecting?
		var client=server.take_connection() #accept
		connection.append(client) #store client
		peerstream.append(PacketPeerStream.new()) #new data transfer object for client
		var index=connection.find(client)
		peerstream [index].set_stream_peer(client) #bind peerstream to new client
		debug.add_text("Client has connected!");debug.newline()
		
	for client in connection:
		if !client.is_connected(): #not connected
			debug.add_text("Client has disconnected");debug.newline()
			var index=connection.find(client)
			connection.remove(index) #removes client connection
			peerstream.remove(index) #removes client peerstream
	for peer in peerstream:
		peer.get_available_packet_count()


func _on_Button_Back_pressed():
	if server:
		server.stop()
	get_node("../Menu").show()
	queue_free() # remove yourself at idle frame
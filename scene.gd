
extends Node


func _ready():
	# connecting signals from buttons. You can also do it via editor
	get_node("Menu/Host").connect("pressed", self, "_on_Button_Host_pressed")
	get_node("Menu/Join").connect("pressed", self, "_on_Button_Join_pressed")

func _on_Button_Host_pressed():
	var new_scene = load("res://server.scn").instance() # loading server scene
	get_node("Menu").hide() # hiding menu, so also it childs
	add_child(new_scene) # adding as child to "Scene" node
	
func _on_Button_Join_pressed():
	var new_scene = load("res://client.scn").instance() # loading client scene
	get_node("Menu").hide() # hiding menu, so also it childs
	new_scene.ip = get_node("Menu/IP").get_text() # changing ip value, want to do this before add_child() to have ip changed before _ready() is fired
	add_child(new_scene) # adding as child to "Scene" node

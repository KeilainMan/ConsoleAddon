@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("ConsoleAndTextchat", "Panel", load("res://addons/console_and_textchat/console.gd"), load("res://addons/console_and_textchat/node_icon.png"))



func _exit_tree() -> void:
	remove_custom_type("ConsoleAnsTextchat")


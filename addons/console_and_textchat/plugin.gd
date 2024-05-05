@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("ConsoleAndTextchat", "Panel", load("res://private_console.gd"), load("res://icon.svg"))



func _exit_tree() -> void:
	remove_custom_type("ConsoleAnsTextchat")


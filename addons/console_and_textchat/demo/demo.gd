extends Node2D


@onready var c_a_t: ConsoleAndTextchat = $ConsoleAndTextchat



func _ready() -> void:
	c_a_t.print_message(c_a_t.col(Color.GREEN, "Hi!"))
	c_a_t.print_message(c_a_t.bold(c_a_t.col("#984447", "This is bold and red dummy text")))
	c_a_t.print_message(c_a_t.italic(c_a_t.crossed("This is italic and crossed dummy text")))
	c_a_t.print_message(c_a_t.col(Color.BLUE_VIOLET, c_a_t.underline("It is already " + c_a_t.timestamp() + "! A late time!")))
	c_a_t.register_command("cheat", cheat, false)
	c_a_t.register_command("troll", troll)

	c_a_t._on_text_input_line_text_submitted("/help")
	c_a_t.delete_command("cheat")
	c_a_t._on_text_input_line_text_submitted("/help")

func cheat() -> void:
	c_a_t.print_message("The cheating command was called!")


func troll(args: Array) -> void:
	c_a_t.print_message("The troll command was called with these arguments: " + " ".join(PackedStringArray(args)))

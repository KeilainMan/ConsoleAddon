extends Node

@onready var primary_console = $HBoxContainer/PrimaryConsole
@onready var console_2 = $HBoxContainer2/HBoxContainer/Console2
@onready var console_3 = $HBoxContainer2/HBoxContainer/Console3


func _ready() -> void:
	primary_console.register_command("cheat", cheat, false)
	primary_console.register_command("troll", troll)
	console_3.register_command("list_args", list_args)

	print_init_messages()


func print_init_messages():
	primary_console.print_message(primary_console.col(Color.GREEN, "Hi!"))
	primary_console.print_message(primary_console.bold(primary_console.col("#984447", "This is bold and red dummy text")))
	primary_console.print_message(primary_console.italic(primary_console.crossed("This is italic and crossed dummy text")))
	primary_console.print_message(primary_console.col(Color.BLUE_VIOLET, primary_console.underline("It is already " + primary_console.timestamp() + "! A late time!")))

	primary_console._on_text_input_line_text_submitted("/help")
	primary_console.print_message(primary_console.col(Color.AQUA, "Try out some of the commands above, you can also use the buttons to interact."))
	primary_console.print_message(primary_console.col(Color.AQUA, "Each console window has it's seperately defined history and registered commands. This means `/help` will differ between consoles."))
	primary_console.print_message(primary_console.col(Color.AQUA, "To try the `/troll` command which is only available in this console you will first need to use the button on the left `PrimaryToggleCLI` which will show/hide the command input."))

	console_2.print_message(primary_console.col(Color.AQUAMARINE, "Using `Shift + Up & Down` Arrow keys you can navigate the message history."))
	console_2.print_message(primary_console.col(Color.AQUAMARINE, "This it out on the console to the right to see history that is cut off from view."))
	console_2.print_message(primary_console.col(Color.LIGHT_CORAL, "When you are previewing history the input will be colored something like this unless overriden."))

	for i in 15:
		console_3._on_text_input_line_text_submitted("Plain Text Line "  + str(i))
	console_3._on_text_input_line_text_submitted("/list_args")
	console_3._on_text_input_line_text_submitted("/clear")
	console_3._on_text_input_line_text_submitted("/list_args arg1 arg2")


func cheat() -> void:
	primary_console.print_message("The cheating command was called!")


func troll(args: Array) -> void:
	primary_console.print_message("The troll command was called with these arguments: " + " ".join(PackedStringArray(args)))


func list_args(args: Array) -> void:
	console_3.print_message("The list_args command was called with these arguments: " + console_3.italic(console_3.col(Color.CADET_BLUE, " ".join(PackedStringArray(args)))))


func _on_console_toggle_cli_pressed(node_path):
	print(node_path)
	var console = get_node(node_path)
	print(console)



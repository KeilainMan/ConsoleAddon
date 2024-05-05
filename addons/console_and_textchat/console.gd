@tool
extends Panel
class_name ConsoleAndTextchat


## NODE DEPENDENCIES ##

@onready var text_input_line: LineEdit
@onready var display_label: RichTextLabel


## EXPORTS ##
@export var minimum_size: Vector2 = Vector2(300,335):
	set(new_size):
		minimum_size = new_size
		size = new_size
		_adjust_display_size(new_size)
		_adjust_text_input_size(new_size)
var all_commands: Array[Dictionary] = []


####################################################################################################
## STARTUP ##


func _ready():
	_build_console()
	set("minimum_size", size)
	_register_premade_commands()

	resized.connect(_on_text_window_resized)



func _build_console() -> void:
	_format_panel()
	_instance_and_setup_children()


func _format_panel() -> void:
	#custom_minimum_size = Vector2(300,335)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL


func _instance_and_setup_children() -> void:
	var vbox: VBoxContainer = VBoxContainer.new()
	add_child(vbox)

	_instance_and_setup_chat_window(vbox)
	_instance_and_setup_text_input(vbox)


func _instance_and_setup_chat_window(parent: VBoxContainer) -> void:
	var display: RichTextLabel = RichTextLabel.new()
	display.name = "DisplayLabel"
	#display.custom_minimum_size = Vector2(300,300)
	display.bbcode_enabled = true
	display.scroll_active = true
	display.scroll_following = true
	display.clip_contents = false
	display.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(display)
	
	display_label = display


func _instance_and_setup_text_input(parent: VBoxContainer) -> void:
	var edit: LineEdit = LineEdit.new()
	edit.name = "TextInputLine"
	edit.custom_minimum_size = Vector2(300,35)
	edit.placeholder_text = "Insert message or command"
	edit.text_submitted.connect(_on_text_input_line_text_submitted.bind())

	parent.add_child(edit)
	text_input_line = edit


####################################################################################################
## CONSOLE OUTPUT ##

func print_message(text: String) -> void:
	display_label.text += "\n"
	display_label.text += text


func _on_false_command_entered() -> void:
	print_message(col(Color.ORANGE_RED, "Error, command not found!"))


func _on_missing_command_arguments() -> void:
	print_message(col(Color.ORANGE_RED, "Error, missing arguments for command!"))


func clear_console() -> void:
	display_label.text = ""
####################################################################################################
## INPUT ##


func _input(event: InputEvent) -> void:
	#toggle console visibility
	if event is InputEventKey and !text_input_line.has_focus():
		if event.pressed == true and event.physical_keycode == KEY_K:
			_toggle_console_visibility()
	
	#grab focus of text input line
	if event is InputEventKey:
		if event.pressed == true and event.physical_keycode == KEY_ENTER \
		and self.visible and !text_input_line.has_focus():
			text_input_line.grab_focus()


func _on_text_input_line_text_submitted(new_text: String) -> void:
	if new_text == "":
		return
	if _input_is_command(new_text):
		_proceed_command(new_text)
	else:
		print_message(new_text)

	text_input_line.text = ""


####################################################################################################
## COMMANDS LOGIC##


func register_command(command_name: String, function: Callable, arguments: bool = true) -> void:
	var blank_command: Dictionary = {
	"command_name": command_name,
	"command_fnc": function,
	"has_args": arguments
	}

	all_commands.append(blank_command)


func delete_command(command_name: String) -> void:
	for command_dic_index in all_commands.size():
		if all_commands[command_dic_index]["command_name"] == command_name:
			all_commands.remove_at(command_dic_index)
			return


func _input_is_command(text: String) -> bool:
	if text.begins_with("/"):
		return true
	else:
		return false


func _proceed_command(text: String) -> void:
	text = text.erase(0, 1) #remove /
	var command_input: PackedStringArray = text.split(" ") #seperate command and arguments
	var command: String = command_input[0]
	
	command_input.remove_at(0) #remove command string to seperate arguments
	var args: Array = Array(command_input)
	for command_dic in all_commands:
		if command_dic["command_name"] == command:
			if command_dic["has_args"] == false:
				command_dic["command_fnc"].call()
				return
			else:
				if args.is_empty():
					_on_missing_command_arguments()
					return
				else:
					command_dic["command_fnc"].call(args)
					return
	
	_on_false_command_entered()


func _register_premade_commands() -> void:
	register_command("help", _help_command, false)
	register_command("toggle_console", _toggle_console_visibility, false)
	register_command("clear", clear_console, false)


################################################################################
## MESSAGE FEATURES ##


func timestamp() -> String:
	var time: Dictionary = Time.get_time_dict_from_system()
	var return_time: String = "[%s:%s]" % [time.get("hour"), time.get("minute")]
	return return_time


################################################################################
## TEXT FORMATTING ##

func col(color, text: String) -> String:
	var col: String
	if color is String:
		if color.begins_with("#") and color.length() == 7:
			col = color
	
	elif color is Color:
		col = "#" + color.to_html(false)
	
	var encasing: String = "[color=%s]" % col
	encasing = encasing + text + "[/color]"
	return encasing


func bold(text: String) -> String:
	return "[b]" + text + "[/b]"


func italic(text: String) -> String:
	return "[i]" + text + "[/i]"


func underline(text: String) -> String:
	return "[u]" + text + "[/u]"
	

func crossed(text: String) -> String:
	return "[s]" + text + "[/s]"


################################################################################
## VISUAL ADJUSTMENTS ##


func _on_text_window_resized() -> void:
	set("minimum_size", size)


func _adjust_display_size(new_size: Vector2) -> void:
	if !display_label == null:
		display_label.custom_minimum_size.x = new_size.x
		display_label.custom_minimum_size.y = new_size.y - text_input_line.custom_minimum_size.y - 5


func _adjust_text_input_size(new_size: Vector2) -> void:
	if !text_input_line == null:
		text_input_line.custom_minimum_size.x = size.x
		text_input_line.custom_minimum_size.y = 35


################################################################################
## REGISTERED COMMANDS ##


func _help_command() -> void:
	print_message(bold(col(Color.BLANCHED_ALMOND, "Here are all registered commands:")))
	for command_dic in all_commands:
		print_message(col(Color.BLANCHED_ALMOND, "/" + command_dic["command_name"]))


func _toggle_console_visibility() -> void:
	if self.visible:
		self.hide()
		return
	else:
		self.show()
		return


################################################################################
## DUMMY ##


func _dummy() -> void:
	return

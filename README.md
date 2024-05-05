# Console and Textchat Addon
 
## Purpose

This addon includes a custom node which can represent a console and textchat. 
You can print messages in game to the console to help you debug or register commands for debugging.

## Installation

Install via Godot AssetLib and enable plugin in project settings.

## How to use

Add the "ConsoleAndTextchat" node to your scene tree. Adjust positioning and size in the scene.

### Printing messages to the console 

To print messages use the `node.print_message(text: String)` method. Insert the string you want to be printed.
You can customize the message using different colors and text formatting or add a timestamp. To see how you 
customize your message look in the demo scene and method documentation.

### Commands

#### Creating commands

To create commands use the `node.register_command(command_name: String, function: Callable, arguments: bool = true)` method.
Enter a name and the method/function to be called upon entering the command into the console. The `arguments` argument describes
wether the callback method has arguments attached. 

#### Calling commands

Calling commands through the console is simple. Every command starts with "/" followed by the command itself. 
Additionally every argument is entered with a space inbetween: "/say_hello_to player_one playert_wo".
The entered arguments are given to the method that was registered to a given comment as an array of Strings `["player_one", "player_two"]`.

### Build in commands

* help\
	Displays all registered commands.

* toggle_console\
	Used to toggle the console. The console can also be toggled using the "K" key.

* clear\
	Used to clear the console of all text.

### Methods

* void		`print_message(text: String)`\
	Main method to print a message to the console/textchat. The `text` string can be customized using the different text formatting methods.
	Text formatting can be achieved with bbcode.
	
* void		`register_command(command_name: String, function: Callable, arguments: bool = true)`\
	Register a command to be used through the console. The `command_name` is written into the console.
	The `function` is a Callable that is called when the `command_name` is entered into the console.
	If the `function` has no arguments set `arguments` to `false`.

* void		`delete_command(command_name: String)`\
	Deletes a registered command.

* void		`clear_console()`\
	Deletes all entered Text.

* String	`timestamp()`\
	Return the current system time in the form [h:min].

* String	`col(color, text: String)`\
	To color a `text` insert `color` as a `Color` type or as a string that represents a html/hex color code in the form #xxxxxx.

* String	`bold(text: String)`\
	To print a `text` in bold.

* String	`italic(text: String)`\
	To print a `text` in italic.

* String	`underline(text: String)`\
	To print a underlined `text`.

* String	`crossed(text: String)`\
	To print a crossed `text`. 

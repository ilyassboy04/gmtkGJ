class_name OptionsMenu
extends Control

@onready var exit_options_button = $MarginContainer/VBoxContainer/Exit_Options_Button as Button

signal exit_options_menu


func _ready():
	
	exit_options_button.button_down.connect(on_exit_pressed)
	set_process(false)
	

func on_exit_pressed() -> void:
	exit_options_menu.emit()
	set_process(false)

# This script handles level transitions and quitting the game.
extends Node2D

# The scene to load for the next level.
@export var next_level: PackedScene  

# Reference to the screen fader for transition effects.
@onready var fader = $CanvasLayer/fader  

# Handles player input for quitting or changing levels.
func _input(event):
	# Checks if the player pressed a key.
	if event is InputEventKey:
		# If ESC is pressed, fade out and quit the game.
		if event.pressed and event.keycode == KEY_ESCAPE:
			fader.fade_screen(true, get_tree().quit)
		
		# If ENTER is pressed, fade out and change to the next level.
		elif event.pressed and event.keycode == KEY_ENTER:
			fader.fade_screen(true, change_level)

# Changes the scene to the next level.
func change_level():
	get_tree().change_scene_to_packed(next_level)

# Provides a warning in the editor if the next level is not assigned.
func _get_configuration_warnings():
	return "ERR! Next level scene is empty" if not next_level else ""

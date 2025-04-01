extends Control

@export var starting_scene: PackedScene

func _ready() -> void:
	%Play.pressed.connect(play)
	%Quit.pressed.connect(quit_game)

func play() -> void:
	if starting_scene:
		get_tree().change_scene_to_packed(starting_scene)
	else:
		print("Error: No scene assigned to 'starting_scene'")

func quit_game():
	get_tree().quit()

extends Control

const MAIN_MENU = preload("res://UserInterface/main-menu.tscn")
func _ready() -> void:
	print("%d" % Event.total_coin  )
	$VBoxContainer2/CoinContainer/Label.text = "%d" % Event.total_coin
	%Play.pressed.connect(play)
	%Quit.pressed.connect(quit_game)

func play() -> void:
	if MAIN_MENU:
		Event.set_total_coin(0)
		get_tree().change_scene_to_file("res://UserInterface/main-menu.tscn")
	else:
		print("Error: No scene assigned to 'main_menu'")

func quit_game():
	get_tree().quit()

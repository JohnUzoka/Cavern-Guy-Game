extends Area2D

class_name Rope

@export var target_scene: PackedScene


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("entered")
		body._on_interaction_area_entered()
		await get_tree().create_timer(1.0).timeout
		exit_level()

func exit_level():
	if target_scene:
		get_tree().change_scene_to_packed(target_scene)
	else:
		print("Error: No scene assigned to 'starting_scene'")

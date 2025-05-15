extends Area2D


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		print("entered")
		if body.damage_taken == false:
			body.update_checkpoint(body.global_position)

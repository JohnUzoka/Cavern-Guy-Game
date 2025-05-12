extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("entered")
		body.update_checkpoint(body.global_position)

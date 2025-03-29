extends Enemy

func _physics_process(delta: float) -> void:
	update_facing_direction()

func update_facing_direction() -> void:
	if velocity.x > 0:
		%AnimatedSprite2D.flip_h = false  # Facing right
	elif velocity.x < 0:
		%AnimatedSprite2D.flip_h = true  # Facing left

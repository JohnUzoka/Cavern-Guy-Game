extends PathFollow2D

var speed = 1
var moving_forward = true
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if moving_forward:
		progress_ratio += delta * speed
		if progress_ratio >= 1.0:
			progress_ratio = 1.0
			moving_forward = false
			animated_sprite_2d.flip_h = true  # Flip only when changing direction
	else:
		progress_ratio -= delta * speed
		if progress_ratio <= 0.0:
			progress_ratio = 0.0
			moving_forward = true
			animated_sprite_2d.flip_h = false  # Unflip only when changing direction

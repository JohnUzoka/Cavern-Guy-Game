extends AnimatedSprite2D  # This script controls an AnimatedSprite2D, which plays animations.

# This function runs once when the node is added to the scene.
func _ready() -> void:  
	# Connects the animation_finished signal to the _on_animation_finished function.  
	# This makes sure that when an animation ends, the function is called.  
	animation_finished.connect(_on_animation_finished)  

	# Starts playing the animation named "Animate".  
	play("Animate")  

# This function runs when the animation finishes playing.  
func _on_animation_finished() -> void:  
	# Removes this node from the game (useful for effects like explosions or temporary visuals).  
	queue_free()  

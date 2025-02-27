extends Area2D  # This script is for an Area2D, which detects when objects enter or leave its space.

# Signal that is emitted when the player enters the area.  
# It sends the direction the enemy should face based on the player's position.  
signal chase_began(new_direction)  

# Signal that is emitted when the player leaves the area,  
# telling the enemy to stop chasing.  
signal chase_ended  

# This function runs when a body (like the player) enters the area.  
func _on_body_entered(body):  
	# Check if the body that entered is the player.  
	if is_player(body):  
		# Emit the chase_began signal and send the direction  
		# (1 if the player is to the right, -1 if to the left).  
		chase_began.emit(sign(body.global_position.x - self.global_position.x))  

# This function runs when a body (like the player) leaves the area.  
func _on_body_exited(body):  
	# Emit the chase_ended signal to stop chasing the player.  
	chase_ended.emit()  

# This function checks if a given node is a Player.  
# It returns "true" if the node is a Player, otherwise "false".  
func is_player(node) -> bool:  
	return node is Player  

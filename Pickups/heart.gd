# This script defines a health pickup that grants extra lives when collected.
extends Pickup  

# The number of lives this pickup grants to the player.
@export var lives: int = 1  

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connects the `body_entered` signal to the function handling the event.
	body_entered.connect(_on_body_entered)

# Handles what happens when another body (e.g., the Player) enters the pickup area.
func _on_body_entered(body):
	# Checks if the colliding body is a Player.
	if body is Player:
		# Grants an extra life only if the player's health is below the maximum.
		if body.player_health < body.MAX_HEALTH:
			body.extra_life(lives)  # Increase the player's health.
			item_collected()  # Call the function to handle the pickup being collected.

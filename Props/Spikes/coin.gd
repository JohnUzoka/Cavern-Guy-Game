# This script defines a collectible gem that increases the player's coin count.
extends Pickup  

# The value of the gem when collected (added to the player's total coins).
@export var coin_value: int = 100  

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connects the `body_entered` signal to the function handling gem collection.
	body_entered.connect(_on_gem_collected)

# Handles what happens when another body (e.g., the Player) collects the gem.
func _on_gem_collected(body) -> void:
	print("collected")  # Debug message to confirm collection.

	# Calls the parent function to handle the pickup disappearing.
	item_collected()

	# Emits a signal to update the coin counter in the UI.
	Event.emit_signal("coin_collected", coin_value)

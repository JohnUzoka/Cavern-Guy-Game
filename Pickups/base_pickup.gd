# Base class for collectible items in the game.
extends Area2D
class_name Pickup  # Defines a reusable Pickup class.

# Preloads the effect that appears when an item is collected.
const ITEM_FEEDBACK = preload("res://Effects/item_feedback_effect.tscn")

# Handles what happens when an item is collected.
func item_collected() -> void:
	# Removes the item from the scene.
	queue_free()

	# Spawns a visual effect to indicate item collection.
	instance_item_feedback()
	
# Creates and displays the item collection feedback effect.
func instance_item_feedback() -> void:
	# Instantiates the feedback effect.
	var item_effect = ITEM_FEEDBACK.instantiate()
	
	# Adds the effect to the same parent as the collected item.
	get_parent().add_child(item_effect)
	
	# Sets the effect's position to match the collected item's position.
	item_effect.global_position = global_position

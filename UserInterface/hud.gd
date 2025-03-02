# This script manages the player's UI elements, such as health and coin count.
extends VBoxContainer

# The scene used to create new health icons (hearts).
@export var health_icon: PackedScene  

# Reference to the container that holds the health icons.
@onready var health_box_container: HBoxContainer = $HealthBoxContainer  

# Called when the node is added to the scene.
func _ready():
	# Connects event signals to handle health and coin changes.
	Event.connect("heath_changed", _on_health_changed)
	Event.connect("coin_collected", _on_coin_collected)

# Updates the coin count UI when a coin is collected.
func _on_coin_collected(value) -> void:
	# Adds the collected coins to the total.
	Event.total_coin += value  

	# Updates the coin counter display.
	$CoinContainer/Label.text = "%d" % Event.total_coin  

# Updates the health UI when the player's health changes.
func _on_health_changed(old_health, new_health, max_health) -> void:
	# Get the current number of health icons (hearts) displayed.
	var lives_left = health_box_container.get_child_count()  

	# If the player lost health, remove excess hearts.
	if old_health > new_health:
		while new_health < lives_left and lives_left > 0:
			# Remove the last heart in the container.
			health_box_container.remove_child(health_box_container.get_child(lives_left - 1))  
			lives_left -= 1  

	# If the player gained health, add new hearts up to the maximum.
	else:
		while lives_left < new_health and lives_left <= max_health:
			# Create a new heart instance.
			var heart = health_icon.instantiate()  
			
			# Add the heart to the health container.
			health_box_container.add_child(heart)  
			
			# Increase the lives count.
			lives_left += 1  

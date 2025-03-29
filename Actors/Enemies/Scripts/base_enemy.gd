extends Actor  # This script defines an Enemy, which is a type of Actor.

class_name Enemy  # Gives this script the name "Enemy" so it can be easily used in the editor.

# The number of points the player gets for defeating this enemy.
@export var pob_point: int = 10  

# Preloads the enemy's death effect (e.g., an explosion or disappearing animation).  
const ENEMYDEATHEFFECT = preload("res://Effects/enemy_death_effect.tscn")  

# This function creates a visual effect when the enemy dies.  
func create_death_effect() -> void:  
	# Creates an instance of the enemy's death effect.  
	var enemyDeathEffect = ENEMYDEATHEFFECT.instantiate()  

	# Adds the death effect to the scene so it appears in the game.  
	get_parent().add_child(enemyDeathEffect)  

	# Sets the effect's position to match the enemy's position.  
	enemyDeathEffect.global_position = global_position  

# This function handles the enemy's death.  
func die() -> void:  
	# Removes the enemy from the game.  
	queue_free()  

	# Calls the function to create the death effect before the enemy disappears.  
	create_death_effect()  

# This script defines a basic character in the game.  
extends CharacterBody2D  # Makes this class a type of CharacterBody2D, which can move and collide with objects.  

# Gives this script the name "Actor" so it can be easily used in other parts of the game.  
class_name Actor  

# The speed at which the character moves. Higher values make it move faster.  
@export var move_speed: float = 300.0  

# The force pulling the character downward, simulating gravity.  
@export var gravity: float = 50.0  

# A function that will handle damage taken by the character.   
func take_damage(damage_amount) -> void:  
	pass  # This means "do nothing for now" - you can add code here later.  

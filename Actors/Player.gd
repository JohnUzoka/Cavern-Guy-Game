# This script defines a Player character that can move and jump in the game.
extends Actor  # Extends the Actor class, making this a Player character

# Assigns a class name "Player" to this script for easy reference in the editor.
class_name Player  

# Signal emitted when the game is over (e.g., when the player runs out of health).
signal game_over  

# Defines the force applied when the player jumps.
@export var jump_impulse: float = 150.0  

# Stores a reference to the player's animated sprite.
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  

# Maximum health the player can have.
const MAX_HEALTH = 3  

# Player's current health.
var player_health: int = 3  

# Runs every physics frame to handle movement and gravity.
func _physics_process(delta):  
	# Gets input direction (-1 for left, 1 for right, 0 if no input).
	var direction = Input.get_axis("move_left", "move_right")  

	# Applies gravity when the player is not on the floor.
	if not is_on_floor():  
		velocity.y += gravity * delta 
		#play fall anim if moving vericallly else play jump
		animated_sprite_2d.play("MidAir" if velocity.y > 0 else "Jump")
	else:
		animated_sprite_2d.play("Run" if direction else "Idle")

	# Makes the player jump if the jump button is pressed and they are on the floor.
	if Input.is_action_just_pressed("jump") and is_on_floor():  
		velocity.y -= jump_impulse  

	# Moves the player left or right based on input.
	if direction:  
		velocity.x = direction * move_speed  
	else:
		# Gradually slows down movement when no input is given.
		velocity.x = move_toward(velocity.x, 0, move_speed)  

	update_facing_direction()
	# Moves the player while handling collisions.
	move_and_slide()  
	
#fucntion t update facing direction if moving in negative direction
func update_facing_direction() -> void:
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true
		
func take_damage(damage_amount) -> void:
		print("Player Was Hurt")

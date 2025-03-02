# This script defines a Player character that can move and jump in the game.
extends Actor  # Extends the Actor class, making this a Player character.

# Assigns a class name "Player" to this script for easy reference in the editor.
class_name Player  

# Signal emitted when the game is over (e.g., when the player runs out of health).
signal game_over

# Defines the force applied when the player jumps.
@export var jump_impulse: float = 170.0  

# Stores a reference to the player's animated sprite.
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  

# Maximum health the player can have.
const MAX_HEALTH = 3  

# Player's current health.
var player_health: int = 3  

# Tracks if the player has recently taken damage to prevent multiple hits in quick succession.
var damage_taken: bool = false  

# Stores the player's initial spawn position for respawning.
var start_position: Vector2  

# Called when the node is added to the scene.
func _ready():
	# Save the player's starting position for future respawns.
	start_position = global_position

# Runs every physics frame to handle movement, gravity, and animations.
func _physics_process(delta):  
	# Gets input direction (-1 for left, 1 for right, 0 if no input).
	var direction = Input.get_axis("move_left", "move_right")  

	# Applies gravity when the player is not on the floor.
	if not is_on_floor():
		velocity.y += gravity * delta  

		# Plays the "MidAir" animation when falling, and "Jump" when moving upward.
		animated_sprite_2d.play("MidAir" if velocity.y > 0 else "Jump")  
	else:
		# Plays "Run" animation if moving, otherwise plays "Idle".
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

	# Updates the player's facing direction based on movement.
	update_facing_direction()

	# Moves the player while handling collisions.
	move_and_slide()
	
# Updates the player's facing direction based on movement.
func update_facing_direction() -> void:
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false  # Facing right
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true  # Facing left
		
# Handles player taking damage.
func take_damage(damage_amount, body) -> void:
	# Prevents taking damage multiple times in quick succession.
	if not damage_taken:
		# Temporarily disable physics processing.
		set_physics_process(false)

		# Play damage animation.
		animated_sprite_2d.play("Hit")

		# Reduce player health.
		var old_health = player_health
		player_health -= damage_amount
		damage_taken = true  # Prevent further damage until recovery.

		# Emit a signal to update the UI with the new health value.
		Event.emit_signal("heath_changed", old_health, player_health, MAX_HEALTH)

		# If the player is still alive, start the revive timer.
		if player_health > 0:
			$ReviveTimer.start()

# Grants the player extra health (e.g., from power-ups).
func extra_life(value) -> void:
	var old_health = player_health
	player_health += value

	# Emit a signal to update the UI with the new health value.
	Event.emit_signal("health_changed", old_health, player_health, MAX_HEALTH)

# Handles player respawning after a short delay.
func _on_revive_timer_timeout() -> void:
	# Reset the player's position to the starting point.
	global_position = start_position

	# Reset animation to "Idle".
	animated_sprite_2d.play("Idle")

	# Allow the player to take damage again.
	damage_taken = false

	# Re-enable physics processing.
	set_physics_process(true)

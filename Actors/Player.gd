# This script defines a Player character that can move and jump in the game.
extends Actor  # Extends the Actor class, making this a Player character.

# Assigns a class name "Player" to this script for easy reference in the editor.
class_name Player  

# Signal emitted when the game is over (e.g., when the player runs out of health).
signal game_over

# Defines the force applied when the player jumps.
@export var jump_impulse: float = 170.0  

# falling sped multiplier
@export var fall_multiplier = 3.5

# Stores a reference to the player's animated sprite.
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  

#area for rope grab interaction
@onready var interaction_area: Area2D = $InteractionArea

# Maximum health the player can have.
const MAX_HEALTH = 3  

# Player's current health.
var player_health: int = 3  

# Tracks if the player has recently taken damage to prevent multiple hits in quick succession.
var damage_taken: bool = false  

# Tracks if player is grabbing a rope
var grabbing_rope: bool = false


# Stores the player's initial spawn position for respawning.
var start_position: Vector2  

# Time window to allow jump after leaving the ground
var jump_buffer_time = 0.2  

# Timer for the jump buffer
var jump_buffer_counter = 0.0  

# Called when the node is added to the scene.
func _ready():
	# Save the player's starting position for future respawns.
	start_position = global_position

# Runs every physics frame to handle movement, gravity, and animations.
func _physics_process(delta):  
	if grabbing_rope:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Gets input direction (-1 for left, 1 for right, 0 if no input).
	var direction = Input.get_axis("move_left", "move_right")  
	velocity.y = min(velocity.y, 400)
	
	# Makes the player jump if the jump button is pressed and they are on the floor.
	# Jump buffer logic
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jump_impulse
		jump_buffer_counter = 0.0  # Reset buffer if we jump
	elif Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer_time  # Start the jump buffer countdown
		
	# Applies gravity when the player is not on the floor.
	if not is_on_floor():
		delay_physics_frames(10)
		if velocity.y > 0:
			velocity.y += gravity * fall_multiplier * delta
		else:
			velocity.y += gravity * delta
		# Plays the "MidAir" animation when falling, and "Jump" when moving upward.
		animated_sprite_2d.play("MidAir" if velocity.y > 0 else "Jump")  
	else:
		# Plays "Run" animation if moving, otherwise plays "Idle".
		animated_sprite_2d.play("Run" if direction else "Idle")  



	# Use jump buffer if within allowed time
	if jump_buffer_counter > 0.0:
		jump_buffer_counter -= delta  # Count down the buffer time
		if is_on_floor():  # If the player touches the floor, make them jump
			velocity.y -= jump_impulse
			jump_buffer_counter = 0.0  # Reset buffer after jumping

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

func delay_physics_frames(frame_count: int):
		if grabbing_rope == false:
			for i in range(frame_count):
				await get_tree().physics_frame

func _on_interaction_area_entered():
	if not is_on_floor():
		grabbing_rope = true
		velocity = Vector2.ZERO
		animated_sprite_2d.play("Grab")
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.play("GrabIdle")

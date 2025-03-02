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

var damage_taken: bool = false

var start_position: Vector2

func _ready():
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
		
# Function to handle player damage.
func take_damage(damage_amount, body) -> void:
	if not damage_taken:
		set_physics_process(false)
		animated_sprite_2d.play("Hit")
		var old_health = player_health
		player_health -= damage_amount
		damage_taken = not damage_taken
		Event.emit_signal("heath_changed", old_health, player_health, MAX_HEALTH)
		if player_health > 0:
			$ReviveTimer.start()

func extra_life(value) -> void:
	var old_health = player_health
	player_health += value
	Event.emit_signal("health_changed", old_health, player_health, MAX_HEALTH)

func _on_revive_timer_timeout() -> void:
	global_position = start_position
	animated_sprite_2d.play("Idle")
	damage_taken = false
	set_physics_process(true)

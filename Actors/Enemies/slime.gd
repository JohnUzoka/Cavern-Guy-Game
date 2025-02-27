extends Enemy  # Inherits functionality from the Enemy class

# Get references to the enemy's animated sprite and cooldown timer.
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  
@onready var cool_timer: Timer = $CoolTimer  

# The force applied when the enemy jumps.
@export var jump_impulse: float = 130.0  

# Variables to track whether the enemy is attacking or just jumped.
var attack_enemy: bool = false  
var just_jumped: bool = false  
var direction: int  # Direction the enemy is facing (1 for right, -1 for left)

# Called when the enemy starts chasing (attack box).
func _on_attack_box_component_chase_began(new_direction):
	# Set the new direction and mark the enemy as attacking.
	direction = new_direction
	attack_enemy = true
	# Update the sprite's facing direction based on chase direction.
	update_facing_direction()

# Called when the enemy stops chasing (attack box).
func _on_attack_box_component_chase_ended():
	# Stop the attack when the chase ends.
	attack_enemy = false
	
# Resets the jumping state after the cooldown timer finishes.
func _on_cool_timer_timeout():
	# Mark the enemy as no longer having just jumped.
	just_jumped = false

# Called every frame to update the enemy's movement and animation.
func _physics_process(delta):
	# Apply gravity if the enemy is in the air.
	if not is_on_floor():
		# Increase gravity's effect on the enemy's movement when in the air.
		velocity.y += gravity * delta * 4
	else:
		# Stop any horizontal movement if the enemy is on the ground.
		velocity = Vector2.ZERO  

	# Update the animation based on movement.
	update_animation()  
	# Handle jumping while chasing.
	jump_chase_movement()  

	# Move the enemy and handle collisions.
	move_and_slide()  

	# Check if the enemy is ready to jump again after a cooldown period.
	if just_jumped and cool_timer.is_stopped() and is_on_floor():
		# Stop any movement before the enemy can jump again.
		velocity = Vector2.ZERO  
		# Restart the cooldown timer to delay the next jump.
		cool_timer.start()  

# Called when the enemy takes damage.
func take_damage(damage_amount, body) -> void:
	# Only take damage if the attack came from above.
	if body.global_position.y > get_node("HurtBoxComponent").global_position.y:
		# Ignore damage if coming from below or the sides.
		return  
	# If the damage is valid, call die() to handle the death of the enemy.
	die()  

# Handles the movement of the enemy when chasing and jumping.
func jump_chase_movement() -> void:
	# If the enemy is attacking, on the floor, and hasn't jumped yet, make it jump.
	if attack_enemy and is_on_floor() and not just_jumped:
		# Apply movement in the current direction and add a jump impulse.
		velocity = Vector2(direction * move_speed, -jump_impulse)  
		# Play the jump animation.
		animated_sprite_2d.play("Jump")  
		# Mark that the enemy has jumped.
		just_jumped = true  

# Updates the enemy's animation based on its current movement state.
func update_animation():
	# If the enemy is falling, play the "Fall" animation.
	if velocity.y > 0:
		animated_sprite_2d.play("Fall")
	# If the enemy is on the ground, play the "Idle" animation.
	if is_on_floor():
		animated_sprite_2d.play("Idle")

# Updates the facing direction of the enemy based on the current movement direction.
func update_facing_direction() -> void:
	# If moving right, flip the sprite to face right.
	if direction > 0:
		animated_sprite_2d.flip_h = true  
	# If moving left, flip the sprite to face left.
	elif direction < 0:
		animated_sprite_2d.flip_h = false  

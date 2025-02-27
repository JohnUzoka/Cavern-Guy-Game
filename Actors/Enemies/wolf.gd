extends Enemy  # This script defines an enemy that moves and chases the player.

# References to RayCast2D nodes that detect danger (like walls or cliffs).
@onready var danger_detector_left: RayCast2D = $DangerDetectorLeft  
@onready var danger_detector_right: RayCast2D = $DangerDetectorRight  

# References to the enemy's animated sprite and animation player.
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  
@onready var animation_player: AnimationPlayer = $AnimationPlayer  

# Movement speeds.
const WALK_SPEED = 90.0  # Normal walking speed.
const RUN_SPEED = 150.0  # Faster speed when chasing the player.
const FRAME_SPEED_SCALE = 0.5  # Controls animation speed increase when running.

# Called when the enemy enters the scene.
func _ready():
	# Sets the default animation speed.
	animated_sprite_2d.speed_scale = 1.0  

	# Randomly decides if the enemy starts moving left or right.
	velocity.x = WALK_SPEED * (-1 if randi_range(0,1) else 1)  

# Called when the enemy detects the player and starts chasing.
func _on_attack_box_component_chase_began(new_direction):
	# Speeds up the animation.
	animated_sprite_2d.speed_scale += FRAME_SPEED_SCALE  

	# Switches to running speed.
	move_speed = RUN_SPEED  

	# Moves the enemy in the direction of the player.
	velocity.x = new_direction * move_speed  

# Called when the player escapes, and the enemy stops chasing.
func _on_attack_box_component_chase_ended():
	# Slows down the animation.
	animated_sprite_2d.speed_scale -= FRAME_SPEED_SCALE  

	# Switches back to walking speed.
	move_speed = WALK_SPEED  

# Runs every physics frame to handle movement, gravity, and animations.
func _physics_process(delta):
	# Applies gravity when the enemy is not on the ground.
	if not is_on_floor():
		velocity.y += gravity  

	# Adjusts movement based on obstacles.
	calculate_move_velocity()  

	# Plays the correct movement animation based on direction.
	animation_player.play("move_right" if velocity.x > 0 else "move_left")  

	# Moves the enemy while handling collisions.
	move_and_slide()  

# Called when the enemy takes damage (currently empty, but can be extended).
func take_damage(amount) -> void:
	die()

# Determines how the enemy should move based on obstacles.
func calculate_move_velocity() -> void:
	# If there is no ground detected on the left OR if the enemy detects a Spike on the left, move right.
	if not danger_detector_left.is_colliding() or (danger_detector_left.is_colliding() and danger_detector_left.get_collider() is Spike):
		velocity.x = move_speed  

	# If there is no ground detected on the right OR if the enemy detects a Spike on the right, move left.
	elif not danger_detector_right.is_colliding() or (danger_detector_right.is_colliding() and danger_detector_right.get_collider() is Spike):
		velocity.x = -move_speed  


	# If the enemy collides with a wall, reverse direction.
	if is_on_wall():
		velocity.x = get_wall_normal().x * move_speed  

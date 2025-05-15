extends Area2D  # This script handles detecting collisions, such as when an enemy or attack hits something.

# References to important child nodes in the scene.
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D  # The shape that detects collisions.
@onready var timer: Timer = $CollisionShape2D/Timer  # A timer used for temporary invincibility.

# This function runs once when the object enters the scene.
func _ready():  
	# Connects the "area_entered" signal to the function that handles collisions.
	self.connect("area_entered", _on_body_entered)  

	# Connects the timer's timeout signal to the function that removes invincibility.
	timer.timeout.connect(_invincibility_timeout)  

# This function runs when another area (like a hitbox) enters this Area2D.
func _on_body_entered(hitbox: HitBox) -> void:  
	# Checks if the owner (the object this script belongs to) has a "take_damage" function.
	if owner.has_method("take_damage"):  
		# Starts temporary invincibility.
		_invincibility_start()

		# Calls the owner's take_damage function and applies the damage from the hitbox.
		owner.take_damage(hitbox.damage, hitbox)
		
	if hitbox.owner.has_method("bounce"):
		hitbox.owner.bounce()

# This function runs when the invincibility timer finishes.
func _invincibility_timeout() -> void:  
	# Enables the collision shape again, allowing the object to take damage.
	collision_shape_2d.disabled = false  

# This function starts invincibility by temporarily disabling collisions.
func _invincibility_start() -> void:  
	# Disables the collision shape to prevent the object from taking damage again too soon.
	collision_shape_2d.set_deferred("disabled", true)  

	# Starts the timer, which will re-enable the collision shape after a short time.
	timer.start()  

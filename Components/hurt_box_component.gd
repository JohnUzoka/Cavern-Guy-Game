extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $CollisionShape2D/Timer

func _ready():
	self.connect("area_entered", _on_body_entered)
	timer.timeout.connect((_invincibility_timeout))
	
func _on_body_entered(hitbox: HitBox) -> void:
	if owner.has_method("take_damage"):
		_invincibility_start()
		owner.take_damage(hitbox.damage)
		
func _invincibility_timeout() -> void:
	collision_shape_2d.disabled = false

func _invincibility_start() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	timer.start()

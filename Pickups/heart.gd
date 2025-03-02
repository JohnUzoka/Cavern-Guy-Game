extends Pickup

@export var lives: int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is Player:
		if body.player_health < body.MAX_HEALTH:
			body.extra_life(lives)
			item_collected()

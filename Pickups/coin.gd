extends Pickup

@export var coin_value: int = 100

func _ready():
	body_entered.connect(_on_gem_collected)
	
func _on_gem_collected(body) -> void:
	print("collected")
	item_collected()
	Event.emit_signal("coin_collected", coin_value)

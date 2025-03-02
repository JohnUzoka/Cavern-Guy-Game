extends VBoxContainer

@export var health_icon: PackedScene

@onready var health_box_container: HBoxContainer = $HealthBoxContainer


func _ready():
	Event.connect("heath_changed", _on_health_changed)
	Event.connect("coin_collected", _on_coin_collected)

func _on_coin_collected(value) -> void:
	Event.total_coin += value
	$CoinContainer/Label.text = "%d" % Event.total_coin

func _on_health_changed(old_health, new_health, max_health) -> void:
	var lives_left = health_box_container.get_child_count()
	
	if old_health > new_health:
		while new_health < lives_left and lives_left > 0:
			health_box_container.remove_child(health_box_container.get_child(lives_left -1))
			lives_left -= 1
	else:
		while lives_left < new_health and lives_left <= max_health:
			var heart = health_icon.instantiate()
			health_box_container.add_child(heart)
			lives_left += 1

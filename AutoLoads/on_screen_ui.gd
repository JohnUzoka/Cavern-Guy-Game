extends Node

signal health_changed(old_health, new_health)
signal coin_collected(value)

var mob_score: int = 1
var total_coin: int = 0:
	set = set_total_coin

func set_total_coin(value) -> void:
	if value != 0:
		total_coin += value
	else:
		total_coin = 0

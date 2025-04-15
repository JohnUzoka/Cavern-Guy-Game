extends Control


func _ready() -> void:
	print("%d" % Event.total_coin  )
	$VBoxContainer2/CoinContainer/Label.text = "%d" % Event.total_coin

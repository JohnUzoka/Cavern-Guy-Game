extends Node

@export var scenes: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if scenes.size() > 0:
		var random_scene = scenes.pick_random()
		var scene_instance = random_scene.instantiate()
		var parent = get_parent()
		parent.add_child(scene_instance)

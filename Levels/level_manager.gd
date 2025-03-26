extends Node

# Array of scene paths to choose from
@export var scenes_to_spawn: Array[PackedScene]

func _ready():
	# Check if there are any scenes in the array
	if scenes_to_spawn.size() > 0:
		# Get a random index
		var random_index = randi() % scenes_to_spawn.size()
		# Get the random scene
		var random_scene = scenes_to_spawn[random_index]
		
		# Instance the scene
		var scene_instance = random_scene.instantiate()
		# Add it as a child
		add_child(scene_instance)

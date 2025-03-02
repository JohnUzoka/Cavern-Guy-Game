# This script handles screen fading effects using a ColorRect overlay.
extends ColorRect

# Tween animation for smooth fading transitions.
var fade_tween: Tween  

# Called when the node enters the scene tree.
func _ready():
	# Initially hides the fader.
	self.visible = false  

# Handles fading the screen in or out.
# @fade_to_black: If true, fades to black. If false, fades out.
# @callback: A function to call after the fade is complete.
func fade_screen(fade_to_black: bool, callback: Callable) -> void:
	# Makes the fader visible when starting the fade effect.
	self.visible = true  

	# Determines the target opacity (1.0 = black, 0.0 = transparent).
	var fader_color = 1.0 if fade_to_black else 0.0  

	# If a fade tween is already running, stop it before starting a new one.
	if is_instance_valid(fade_tween) && fade_tween.is_running():
		fade_tween.stop()  

	# Creates a new tween animation for the fade effect.
	fade_tween = get_tree().create_tween()
	fade_tween.tween_property(self, "modulate:a", fader_color, 1.5)  

	# Calls the provided function (e.g., changing levels) after fading is done.
	if not callback.is_null():
		fade_tween.tween_callback(callback)  

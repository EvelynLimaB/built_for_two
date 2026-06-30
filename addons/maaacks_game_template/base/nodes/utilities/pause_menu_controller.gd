extends Node

@export var pause_menu_scene : PackedScene

var pause_menu_instance : Control
var is_paused := false
var is_closing_via_button := false  # Tracks if Resume button was clicked


func _ready() -> void:
	if not pause_menu_scene:
		push_error("Pause menu scene not assigned!")
		return
	
	pause_menu_instance = pause_menu_scene.instantiate()
	pause_menu_instance.process_mode = PROCESS_MODE_ALWAYS  # Keeps animations/shortcuts alive
	pause_menu_instance.hide()
	
	# CRITICAL: Attach to ROOT, not current_scene
	get_tree().root.add_child.call_deferred(pause_menu_instance)
	
	# Connect the "Resume" button signal (assuming it exists)
	# If you have a signal in your pause menu called "resume_pressed":
	# pause_menu_instance.resume_pressed.connect(_on_resume_button_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause() -> void:
	if is_paused:
		resume_game()
	else:
		pause_game()


func pause_game() -> void:
	if is_paused:
		return
	if not is_instance_valid(pause_menu_instance):
		# Safety net: recreate if accidentally destroyed
		recreate_menu()
		if not is_instance_valid(pause_menu_instance):
			return
	
	is_paused = true
	is_closing_via_button = false  # Reset flag
	
	# Store current focus BEFORE pausing
	var current_focus = get_viewport().gui_get_focus_owner()
	
	get_tree().paused = true
	pause_menu_instance.show()
	
	# Wait for the menu to close
	await pause_menu_instance.visibility_changed
	
	# If the menu was destroyed during the await, abort
	if not is_instance_valid(pause_menu_instance):
		return
	
	# If the user clicked "Resume", we already handled focus in resume_game()
	# If they pressed Escape again, we restore the original focus
	if not is_closing_via_button:
		# Restore only if valid
		if is_instance_valid(current_focus) and current_focus.is_inside_tree():
			current_focus.grab_focus()


func resume_game() -> void:
	if not is_paused:
		return
	if not is_instance_valid(pause_menu_instance):
		return
	
	is_closing_via_button = true  # Mark that we are closing via UI interaction
	
	# Determine where focus should go (usually the game viewport)
	var next_focus = get_viewport().gui_get_focus_owner()
	
	is_paused = false
	get_tree().paused = false
	pause_menu_instance.hide()
	
	# Restore focus to the game if possible
	if is_instance_valid(next_focus) and next_focus.is_inside_tree():
		next_focus.grab_focus()


# Call this from your "Resume" button's pressed signal
func _on_resume_button_pressed() -> void:
	resume_game()


func recreate_menu() -> void:
	if not pause_menu_scene:
		return
	if is_instance_valid(pause_menu_instance):
		pause_menu_instance.queue_free()
	
	pause_menu_instance = pause_menu_scene.instantiate()
	pause_menu_instance.process_mode = PROCESS_MODE_ALWAYS
	pause_menu_instance.hide()
	get_tree().root.add_child(pause_menu_instance)

extends Node

## Global Pause Manager
## Handles Esc key, pausing/unpausing the game, and managing the pause menu UI.

@export var pause_menu_scene : PackedScene  # Assign in the Inspector

var pause_menu_instance : Control
var is_paused := false


func _ready() -> void:
	# Defer initialization to ensure the scene tree is fully ready
	call_deferred("_initialize_pause_menu")


func _initialize_pause_menu() -> void:
	if not pause_menu_scene:
		# Fallback: try to load from a known path if not assigned
		var default_path = "res://scenes/menus/pause_menu.tscn"
		if ResourceLoader.exists(default_path):
			pause_menu_scene = load(default_path) as PackedScene
		else:
			push_error("PauseHandler: No pause menu scene assigned and default not found!")
			return

	pause_menu_instance = pause_menu_scene.instantiate()
	# Allow the menu to process input even when the game is paused
	pause_menu_instance.process_mode = PROCESS_MODE_ALWAYS
	pause_menu_instance.hide()
	# Attach to the root viewport – survives scene changes
	get_tree().root.add_child.call_deferred(pause_menu_instance)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and pause_menu_instance:
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
		_initialize_pause_menu()
		if not is_instance_valid(pause_menu_instance):
			return

	is_paused = true
	get_tree().paused = true
	pause_menu_instance.show()


func resume_game() -> void:
	if not is_paused:
		return
	if not is_instance_valid(pause_menu_instance):
		return

	is_paused = false
	get_tree().paused = false
	pause_menu_instance.hide()


## Called before switching scenes to ensure the new scene isn't paused
func prepare_for_scene_change() -> void:
	if is_paused:
		get_tree().paused = false
		is_paused = false
	if is_instance_valid(pause_menu_instance):
		pause_menu_instance.hide()


## Called by the "Quit to Main Menu" button in the pause menu
func quit_to_main_menu() -> void:
	prepare_for_scene_change()
	# Use your SceneLoader or LevelAndStateManager to change scene
	# Example: SceneLoader.load_scene("res://scenes/menus/main_menu.tscn")
	# If you don't have a SceneLoader, use:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

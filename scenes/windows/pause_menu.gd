@tool
extends OverlaidWindow

## ============================================================================
## EXPORTS & ONREADYS
## ============================================================================

@export var options_menu_scene : PackedScene
@export var save_gallery_scene : PackedScene

@export_file("*.tscn") var main_menu_scene_path : String
@export_node_path(&"ConfirmationOverlaidWindow") var restart_confirmation_node_path : NodePath
@export_node_path(&"ConfirmationOverlaidWindow") var main_menu_confirmation_node_path : NodePath
@export_node_path(&"ConfirmationOverlaidWindow") var exit_confirmation_node_path : NodePath
@export var menu_container_node_path : NodePath = ^".."

@onready var restart_confirmation : ConfirmationOverlaidWindow = get_node_or_null(restart_confirmation_node_path)
@onready var main_menu_confirmation : ConfirmationOverlaidWindow = get_node_or_null(main_menu_confirmation_node_path)
@onready var exit_confirmation : ConfirmationOverlaidWindow = get_node_or_null(exit_confirmation_node_path)
@onready var menu_container : Node = get_node_or_null(menu_container_node_path)

@onready var options_button = %OptionsButton
@onready var main_menu_button = %MainMenuButton
@onready var exit_button = %ExitButton
@onready var save_load_button = %MenuButtons.get_node_or_null("SaveLoadButton")
@onready var resume_button = %ResumeButton  # <-- Make sure you have this in your scene

var open_window : Node
var frame_opened : int = 0

## ============================================================================
## READY & REFRESH
## ============================================================================

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS 
	ui_cancel_closes = false
	
	_refresh_exit_button()
	_refresh_options_button()
	_refresh_main_menu_button()
	_refresh_save_buttons()
	
	# Connect confirmation dialogs
	if restart_confirmation:
		restart_confirmation.confirmed.connect(_on_restart_confirmation_confirmed)
	if main_menu_confirmation:
		main_menu_confirmation.confirmed.connect(_on_main_menu_confirmation_confirmed)
	if exit_confirmation:
		exit_confirmation.confirmed.connect(_on_exit_confirmation_confirmed)
	
	# Connect the Resume button directly to the PauseHandler
	if resume_button:
		resume_button.pressed.connect(_on_resume_button_pressed)

func _refresh_exit_button() -> void:
	if exit_button: 
		exit_button.visible = !OS.has_feature("web")

func _refresh_options_button() -> void:
	if options_button: 
		options_button.visible = options_menu_scene != null

func _refresh_main_menu_button() -> void:
	if main_menu_button: 
		main_menu_button.visible = !get_main_menu_scene_path().is_empty()

func _refresh_save_buttons() -> void:
	if save_load_button: 
		save_load_button.visible = true

func get_main_menu_scene_path() -> String:
	if main_menu_scene_path.is_empty():
		return AppConfig.main_menu_scene_path
	return main_menu_scene_path

## ============================================================================
## WINDOW MANAGEMENT
## ============================================================================

func close_window() -> void:
	if open_window != null:
		if open_window.has_method("close"): 
			open_window.close()
		else:
			open_window.hide()
			open_window.queue_free()
		open_window = null

func _disable_focus() -> void:
	var menu_buttons = %MenuButtons
	if not menu_buttons:
		return
	for child in menu_buttons.get_children():
		if child is Control:
			child.focus_mode = FOCUS_NONE

func _enable_focus() -> void:
	var menu_buttons = %MenuButtons
	if not menu_buttons:
		return
	for child in menu_buttons.get_children():
		if child is Control:
			child.focus_mode = FOCUS_ALL

func _show_window(window : Control) -> void:
	_disable_focus.call_deferred()
	window.show()
	open_window = window
	await window.hidden
	open_window = null
	_enable_focus.call_deferred()

## ============================================================================
## ENGINE-LEVEL INPUT HANDLING
## ============================================================================

func show() -> void:
	super.show()
	frame_opened = Engine.get_process_frames()

func _input(event: InputEvent) -> void:
	if visible and open_window == null and event.is_action_pressed("ui_cancel", false): 
		if Engine.get_process_frames() == frame_opened:
			return
		get_viewport().set_input_as_handled()
		# Instead of just closing, we tell the PauseHandler to resume the game.
		# This will unpause and hide the menu in one go.
		PauseHandler.resume_game()

## ============================================================================
## CLOSE LOGIC
## ============================================================================

func close() -> void:
	# Just hide the UI – the PauseHandler manages the lifecycle and pause state.
	super.close() 

## ============================================================================
## BUTTON SIGNALS
## ============================================================================

func _on_resume_button_pressed() -> void:
	# Delegate to the global PauseHandler
	PauseHandler.resume_game()

func _on_options_button_pressed() -> void:
	if options_menu_scene == null: 
		return
	var options = options_menu_scene.instantiate()
	options.process_mode = Node.PROCESS_MODE_ALWAYS
	menu_container.add_child.call_deferred(options)
	_show_window(options)

func _on_main_menu_button_pressed() -> void:
	if main_menu_confirmation: 
		_show_window(main_menu_confirmation)

func _on_exit_button_pressed() -> void:
	if exit_confirmation: 
		_show_window(exit_confirmation)

func _on_restart_confirmation_confirmed() -> void:
	# The PauseHandler will unpause and hide the menu before reloading
	PauseHandler.prepare_for_scene_change()
	SceneLoader.reload_current_scene()

func _on_main_menu_confirmation_confirmed():
	PauseHandler.prepare_for_scene_change()
	SceneLoader.load_scene(get_main_menu_scene_path())

func _on_exit_confirmation_confirmed():
	PauseHandler.prepare_for_scene_change()
	get_tree().quit()

func _on_save_load_button_pressed():
	if save_gallery_scene == null: 
		return
		
	var gallery = save_gallery_scene.instantiate()
	
	# ✅ Use class_name if available; fallback to int if not
	if gallery.has_method("set_mode") or "Mode" in gallery:
		gallery.current_mode = SaveGallery.Mode.SAVE if "SaveGallery" in get_script().get_global_name() else 0
	else:
		gallery.current_mode = 0  # fallback
	
	gallery.process_mode = Node.PROCESS_MODE_ALWAYS 
	gallery.close_menu_requested.connect(func(): close())
	
	menu_container.add_child(gallery)
	_show_window(gallery)

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

var open_window : Node

# ✅ THE FIX: Tracks the exact engine frame the menu opens
var frame_opened : int = 0

## ============================================================================
## READY & REFRESH
## ============================================================================

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS 
	ui_cancel_closes = false # ✅ Prevents the menu from closing on key release
	
	_refresh_exit_button()
	_refresh_options_button()
	_refresh_main_menu_button()
	_refresh_save_buttons()
	
	if restart_confirmation:
		restart_confirmation.confirmed.connect(_on_restart_confirmation_confirmed)
	if main_menu_confirmation:
		main_menu_confirmation.confirmed.connect(_on_main_menu_confirmation_confirmed)
	if exit_confirmation:
		exit_confirmation.confirmed.connect(_on_exit_confirmation_confirmed)

func _refresh_exit_button() -> void:
	if exit_button: exit_button.visible = !OS.has_feature("web")

func _refresh_options_button() -> void:
	if options_button: options_button.visible = options_menu_scene != null

func _refresh_main_menu_button() -> void:
	if main_menu_button: main_menu_button.visible = !get_main_menu_scene_path().is_empty()

func _refresh_save_buttons() -> void:
	var has_save_manager = SaveManager != null
	if save_load_button: save_load_button.visible = has_save_manager

func get_main_menu_scene_path() -> String:
	if main_menu_scene_path.is_empty():
		return AppConfig.main_menu_scene_path
	return main_menu_scene_path

## ============================================================================
## WINDOW MANAGEMENT
## ============================================================================

func close_window() -> void:
	if open_window != null:
		if open_window.has_method("close"): open_window.close()
		else:
			open_window.hide()
			open_window.queue_free()
		open_window = null

func _disable_focus() -> void:
	for child in %MenuButtons.get_children():
		if child is Control: child.focus_mode = FOCUS_NONE

func _enable_focus() -> void:
	for child in %MenuButtons.get_children():
		if child is Control: child.focus_mode = FOCUS_ALL

func _show_window(window : Control) -> void:
	_disable_focus.call_deferred()
	window.show()
	open_window = window
	await window.hidden
	open_window = null
	_enable_focus.call_deferred()

## ============================================================================
## ENGINE-LEVEL INPUT HANDLING (THE MASTER FIX)
## ============================================================================

func show() -> void:
	super.show()
	# ✅ Record the exact engine frame this menu appeared on the screen
	frame_opened = Engine.get_process_frames()

func _input(event: InputEvent) -> void:
	# ✅ Added 'false' to explicitly ignore echo/held key events
	if visible and event.is_action_pressed("ui_cancel", false): 
		if Engine.get_process_frames() == frame_opened:
			return
			
		get_viewport().set_input_as_handled()
		_handle_cancel_input()

func _handle_cancel_input() -> void:
	if open_window != null:
		close_window()
	else:
		super._handle_cancel_input()

func close() -> void:
	var parent = get_parent()
	super.close() # Let the window do its normal closing routine
	
	# ✅ Destroy the parent CanvasLayer so PauseMenuController can open a new one later
	if parent is CanvasLayer:
		parent.queue_free()

## ============================================================================
## BUTTON SIGNALS
## ============================================================================

func _on_options_button_pressed() -> void:
	if options_menu_scene == null: return
	var options = options_menu_scene.instantiate()
	options.process_mode = Node.PROCESS_MODE_ALWAYS
	menu_container.add_child.call_deferred(options)
	_show_window(options)

func _on_main_menu_button_pressed() -> void:
	if main_menu_confirmation: _show_window(main_menu_confirmation)

func _on_exit_button_pressed() -> void:
	if exit_confirmation: _show_window(exit_confirmation)

func _on_restart_confirmation_confirmed() -> void:
	get_tree().paused = false
	SceneLoader.reload_current_scene()
	close()

func _on_main_menu_confirmation_confirmed():
	get_tree().paused = false
	SceneLoader.load_scene(get_main_menu_scene_path())

func _on_exit_confirmation_confirmed():
	get_tree().quit()

func _on_save_load_button_pressed():
	if save_gallery_scene == null: return
		
	var gallery = save_gallery_scene.instantiate()
	gallery.current_mode = gallery.Mode.SAVE
	gallery.process_mode = Node.PROCESS_MODE_ALWAYS 
	
	gallery.close_menu_requested.connect(func(): close())
	
	menu_container.add_child(gallery)
	_show_window(gallery)

@tool
extends OverlaidWindow

## ============================================================================
## EXPORTS
## ============================================================================

@export var options_menu_scene : PackedScene
@export var save_gallery_scene : PackedScene # ✅ Drop your SaveGalleryMenu.tscn here!

@export_file("*.tscn") var main_menu_scene_path : String
@export_node_path(&"ConfirmationOverlaidWindow") var restart_confirmation_node_path : NodePath
@export_node_path(&"ConfirmationOverlaidWindow") var main_menu_confirmation_node_path : NodePath
@export_node_path(&"ConfirmationOverlaidWindow") var exit_confirmation_node_path : NodePath
@export var menu_container_node_path : NodePath = ^".."

## ============================================================================
## ONREADY NODES
## ============================================================================

@onready var restart_confirmation : ConfirmationOverlaidWindow = get_node_or_null(restart_confirmation_node_path)
@onready var main_menu_confirmation : ConfirmationOverlaidWindow = get_node_or_null(main_menu_confirmation_node_path)
@onready var exit_confirmation : ConfirmationOverlaidWindow = get_node_or_null(exit_confirmation_node_path)
@onready var menu_container : Node = get_node_or_null(menu_container_node_path)

## ============================================================================
## UI REFERENCES
## ============================================================================

@onready var options_button = %OptionsButton
@onready var main_menu_button = %MainMenuButton
@onready var exit_button = %ExitButton
# ✅ Looks for your specific SaveLoadButton inside the MenuButtons container
@onready var save_load_button = %MenuButtons.get_node_or_null("SaveLoadButton")

var open_window : Node
var _ignore_first_cancel : bool = false

## ============================================================================
## READY & UI REFRESH
## ============================================================================

func _ready() -> void:
	# ✅ CRITICAL FIX: Forces this menu to accept mouse clicks when paused!
	process_mode = Node.PROCESS_MODE_ALWAYS 
	
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

## ============================================================================
## WINDOW MANAGEMENT
## ============================================================================

func get_main_menu_scene_path() -> String:
	if main_menu_scene_path.is_empty():
		return AppConfig.main_menu_scene_path
	return main_menu_scene_path

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

func _load_scene(scene_path: String) -> void:
	get_tree().paused = false
	SceneLoader.load_scene(scene_path)

func _load_and_show_menu(scene : PackedScene) -> void:
	if scene == null: return
	var window_instance : Control = scene.instantiate()
	window_instance.visible = false
	
	# ✅ Force sub-menus to stay awake during pause
	window_instance.process_mode = Node.PROCESS_MODE_ALWAYS
	
	menu_container.add_child.call_deferred(window_instance)
	await _show_window(window_instance)
	window_instance.queue_free()

func _show_window(window : Control) -> void:
	_disable_focus.call_deferred()
	window.show()
	open_window = window
	await window.hidden
	open_window = null
	_enable_focus.call_deferred()

## ============================================================================
## INPUT HANDLING
## ============================================================================

func _handle_cancel_input() -> void:
	if _ignore_first_cancel:
		_ignore_first_cancel = false
		return
	if open_window != null:
		close_window()
	else:
		super._handle_cancel_input()

func show() -> void:
	# ✅ Take the Dialogic thumbnail BEFORE the menu overlay appears on screen
	if Dialogic.has_subsystem("Save"):
		Dialogic.Save.take_thumbnail()
		
	super.show()
	if Input.is_action_pressed("ui_cancel"):
		_ignore_first_cancel = true

## ============================================================================
## SIGNAL HANDLERS
## ============================================================================

func _on_options_button_pressed() -> void:
	_load_and_show_menu(options_menu_scene)

func _on_main_menu_button_pressed() -> void:
	if main_menu_confirmation: _show_window(main_menu_confirmation)

func _on_exit_button_pressed() -> void:
	if exit_confirmation: _show_window(exit_confirmation)

func _on_restart_confirmation_confirmed() -> void:
	SceneLoader.reload_current_scene()
	close()

func _on_main_menu_confirmation_confirmed():
	_load_scene(get_main_menu_scene_path())

func _on_exit_confirmation_confirmed():
	get_tree().quit()

## ============================================================================
## NEW: SAVE GALLERY INTEGRATION
## ============================================================================

func _on_save_load_button_pressed():
	if save_gallery_scene == null:
		push_error("❌ Save Gallery Scene not assigned in inspector!")
		return
		
	var gallery = save_gallery_scene.instantiate()
	
	# ✅ Default to SAVE mode since the player is in the pause menu
	gallery.current_mode = gallery.Mode.SAVE
	
	# ✅ Force the gallery to stay awake and not freeze!
	gallery.process_mode = Node.PROCESS_MODE_ALWAYS 
	
	# Listen for the gallery's request to close the menu
	gallery.close_menu_requested.connect(func():
		close()
	)
	
	menu_container.add_child(gallery)
	_show_window(gallery)

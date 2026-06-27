@tool
extends OverlaidWindow

## ============================================================================
## EXPORTS
## ============================================================================

@export var options_menu_scene : PackedScene

## Path to a main menu scene. Will attempt to read from AppConfig if left empty.
@export_file("*.tscn") var main_menu_scene_path : String

@export_node_path(&"ConfirmationOverlaidWindow") var restart_confirmation_node_path : NodePath
@export_node_path(&"ConfirmationOverlaidWindow") var main_menu_confirmation_node_path : NodePath
@export_node_path(&"ConfirmationOverlaidWindow") var exit_confirmation_node_path : NodePath
@export var menu_container_node_path : NodePath = ^".."

## Slot name for saving. Players can change this in the menu.
@export var current_save_slot: String = "slot_1"

## ============================================================================
## ONREADY NODES (com fallback)
## ============================================================================

@onready var restart_confirmation : ConfirmationOverlaidWindow = get_node(restart_confirmation_node_path) if restart_confirmation_node_path else null
@onready var main_menu_confirmation : ConfirmationOverlaidWindow = get_node(main_menu_confirmation_node_path) if main_menu_confirmation_node_path else null
@onready var exit_confirmation : ConfirmationOverlaidWindow = get_node(exit_confirmation_node_path) if exit_confirmation_node_path else null
@onready var menu_container : Node = get_node(menu_container_node_path) if menu_container_node_path else null

## ============================================================================
## UI REFERENCES
## ============================================================================

@onready var options_button = %OptionsButton
@onready var main_menu_button = %MainMenuButton
@onready var exit_button = %ExitButton
@onready var save_button = %SaveButton
@onready var load_button = %LoadButton

## ============================================================================
## VARIABLES
## ============================================================================

var open_window : Node
var _ignore_first_cancel : bool = false

## ============================================================================
## SCENE PATH HELPERS
## ============================================================================

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
			# ✅ Remover da árvore após esconder
			open_window.queue_free()
		open_window = null

func _disable_focus() -> void:
	for child in %MenuButtons.get_children():
		if child is Control:
			child.focus_mode = FOCUS_NONE

func _enable_focus() -> void:
	for child in %MenuButtons.get_children():
		if child is Control:
			child.focus_mode = FOCUS_ALL

## ============================================================================
## SCENE LOADING
## ============================================================================

func _load_scene(scene_path: String) -> void:
	# ✅ Despausar antes de carregar
	get_tree().paused = false
	SceneLoader.load_scene(scene_path)

func _load_and_show_menu(scene : PackedScene) -> void:
	if scene == null:
		push_error("❌ Menu scene is null")
		return
	
	var window_instance : Control = scene.instantiate()
	window_instance.visible = false
	menu_container.add_child.call_deferred(window_instance)
	await _show_window(window_instance)
	# ✅ Cleanup após fechar
	window_instance.queue_free()

## ============================================================================
## WINDOW DISPLAY
## ============================================================================

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
	super.show()
	if Input.is_action_pressed("ui_cancel"):
		_ignore_first_cancel = true

## ============================================================================
## UI REFRESH
## ============================================================================

func _refresh_exit_button() -> void:
	exit_button.visible = !OS.has_feature("web")

func _refresh_options_button() -> void:
	options_button.visible = options_menu_scene != null

func _refresh_main_menu_button() -> void:
	main_menu_button.visible = !get_main_menu_scene_path().is_empty()

func _refresh_save_buttons() -> void:
	# ✅ Mostrar botões de save/load apenas se o SaveManager existir
	var has_save_manager = SaveManager != null
	save_button.visible = has_save_manager
	load_button.visible = has_save_manager and SaveManager.has_save(current_save_slot)

## ============================================================================
## READY
## ============================================================================

func _ready() -> void:
	_refresh_exit_button()
	_refresh_options_button()
	_refresh_main_menu_button()
	_refresh_save_buttons()
	
	# ✅ Verificar se os nós de confirmação existem antes de conectar
	if restart_confirmation:
		restart_confirmation.confirmed.connect(_on_restart_confirmation_confirmed)
	if main_menu_confirmation:
		main_menu_confirmation.confirmed.connect(_on_main_menu_confirmation_confirmed)
	if exit_confirmation:
		exit_confirmation.confirmed.connect(_on_exit_confirmation_confirmed)
	
	# ✅ Conectar sinais de SaveManager para atualizar UI
	if SaveManager:
		SaveManager.game_saved.connect(_refresh_save_buttons)
		SaveManager.game_loaded.connect(_refresh_save_buttons)

## ============================================================================
## SIGNAL HANDLERS
## ============================================================================

func _on_restart_button_pressed() -> void:
	if restart_confirmation:
		_show_window(restart_confirmation)

func _on_options_button_pressed() -> void:
	_load_and_show_menu(options_menu_scene)

func _on_main_menu_button_pressed() -> void:
	if main_menu_confirmation:
		_show_window(main_menu_confirmation)

func _on_exit_button_pressed() -> void:
	if exit_confirmation:
		_show_window(exit_confirmation)

func _on_restart_confirmation_confirmed() -> void:
	SceneLoader.reload_current_scene()
	close()

func _on_main_menu_confirmation_confirmed():
	_load_scene(get_main_menu_scene_path())

func _on_exit_confirmation_confirmed():
	get_tree().quit()

## ============================================================================
## SAVE / LOAD (com validação)
## ============================================================================

func _on_save_button_pressed():
	if SaveManager == null:
		push_error("❌ SaveManager not found!")
		return
	
	# ✅ Usa o slot atual (pode ser alterado pelo player)
	SaveManager.save_game(current_save_slot, SaveManager.create_extra_info())
	_refresh_save_buttons()
	
	# ✅ Feedback visual
	save_button.text = "✅ Saved!"
	await get_tree().create_timer(1.0).timeout
	save_button.text = "Save"

func _on_load_button_pressed():
	if SaveManager == null:
		push_error("❌ SaveManager not found!")
		return
	
	if SaveManager.has_save(current_save_slot):
		var loaded = SaveManager.load_game(current_save_slot)
		if loaded:
			# ✅ Fechar o menu e despausar
			get_tree().paused = false
			close()
		else:
			push_error("❌ Failed to load save from slot: ", current_save_slot)
	else:
		push_warning("ℹ️ No save found in slot: ", current_save_slot)

## ============================================================================
## SLOT SELECTION (para múltiplos saves)
## ============================================================================

func set_current_save_slot(slot_name: String) -> void:
	current_save_slot = slot_name
	_refresh_save_buttons()
	print("📂 Current save slot changed to: ", slot_name)

## ============================================================================
## VALIDATION
## ============================================================================

func _validate_nodes() -> bool:
	var valid = true
	if restart_confirmation == null:
		push_warning("⚠️ restart_confirmation node not found")
		valid = false
	if main_menu_confirmation == null:
		push_warning("⚠️ main_menu_confirmation node not found")
		valid = false
	if exit_confirmation == null:
		push_warning("⚠️ exit_confirmation node not found")
		valid = false
	if menu_container == null:
		push_warning("⚠️ menu_container node not found")
		valid = false
	return valid

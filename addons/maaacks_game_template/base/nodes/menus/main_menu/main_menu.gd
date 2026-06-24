class_name MainMenu
extends Control
## Base menu scene that links to a game scene, an options menu, and credits.

signal sub_menu_opened
signal sub_menu_closed
signal game_started
signal game_exited

## Defines the path to the game scene. Hides the play button if empty.
## Will attempt to read from AppConfig if left empty.
@export_file("*.tscn") var game_scene_path : String
## The scene to open when a player clicks the 'Options' button.
@export var options_packed_scene : PackedScene
## The scene to open when a player clicks the 'Credits' button.
@export var credits_packed_scene : PackedScene
@export var confirm_exit : bool = true
@export_group("Extra Settings")
## If true, signals that the game has started loading in the background, instead of directly loading it.
@export var signal_game_start : bool = false
## If true, signals that the player clicked the 'Exit' button, instead of immediately exiting.
@export var signal_game_exit : bool = false

var sub_menu : Control

@onready var menu_container = %MenuContainer
@onready var menu_buttons_box_container = %MenuButtonsBoxContainer
@onready var new_game_button = %NewGameButton
@onready var options_button = %OptionsButton
@onready var credits_button = %CreditsButton
@onready var exit_button = %ExitButton
@onready var exit_confirmation = %ExitConfirmation

@export var chapter_select_packed_scene: PackedScene
@export var confirm_new_game : bool = true

var animation_state_machine : AnimationNodeStateMachinePlayback

@onready var continue_game_button = %ContinueGameButton
@onready var chapter_select_button = %ChapterSelectButton
@onready var new_game_confirmation = %NewGameConfirmation

# ✅ Override load_game_scene to use SceneLoader
func load_game_scene() -> void:
	# The GameState already has the chapter path set
	# Just load the game scene
	SceneLoader.load_scene("res://scenes/game_scene/game_ui.tscn")

func new_game() -> void:
	if confirm_new_game and continue_game_button.visible:
		new_game_confirmation.show()
	else:
		GameState.reset()
		load_game_scene()

# ... rest of your existing functions ...

func _ready() -> void:
	_hide_exit_for_web()
	_hide_options_if_unset()
	_hide_credits_if_unset()
	_hide_new_game_if_unset()
	_show_chapter_select_if_set()
	_show_continue_if_set()
	animation_state_machine = $MenuAnimationTree.get("parameters/playback")

func _show_chapter_select_if_set() -> void: 
	if chapter_select_packed_scene == null: return
	if GameState.get_chapters_reached() <= 1: return
	chapter_select_button.show()

func _show_continue_if_set() -> void:
	if GameState.get_current_chapter_path().is_empty(): return
	continue_game_button.show()

func _on_continue_game_button_pressed() -> void:
	GameState.continue_game()
	load_game_scene()

func _on_chapter_select_button_pressed() -> void:
	var chapter_select_scene := _open_sub_menu(chapter_select_packed_scene)
	if chapter_select_scene.has_signal("chapter_selected"):
		chapter_select_scene.connect("chapter_selected", _on_chapter_selected)

func _on_chapter_selected() -> void:
	# Chapter select has already set the path and LevelManager
	load_game_scene()

func _on_new_game_confirmation_confirmed() -> void:
	GameState.reset()
	load_game_scene()

func get_game_scene_path() -> String:
	if game_scene_path.is_empty():
		return AppConfig.game_scene_path
	return game_scene_path

func try_exit_game() -> void:
	if confirm_exit and (not exit_confirmation.visible):
		exit_confirmation.show()
	else:
		exit_game()

func exit_game() -> void:
	if OS.has_feature("web"):
		return
	if signal_game_exit:
		game_exited.emit()
	else:
		get_tree().quit()

func _open_sub_menu(menu : PackedScene) -> Node:
	sub_menu = menu.instantiate()
	add_child(sub_menu)
	menu_container.hide()
	sub_menu.hidden.connect(_close_sub_menu, CONNECT_ONE_SHOT)
	sub_menu.tree_exiting.connect(_close_sub_menu, CONNECT_ONE_SHOT)
	sub_menu_opened.emit()
	return sub_menu

func _close_sub_menu() -> void:
	if sub_menu == null:
		return
	sub_menu.queue_free()
	sub_menu = null
	menu_container.show()
	sub_menu_closed.emit()

func _event_is_mouse_button_released(event : InputEvent) -> bool:
	return event is InputEventMouseButton and not event.is_pressed()

func _input(event : InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		if sub_menu:
			_close_sub_menu()
		else:
			try_exit_game()
	if event.is_action_released("ui_accept") and get_viewport().gui_get_focus_owner() == null:
		menu_buttons_box_container.focus_first()

func _hide_exit_for_web() -> void:
	if OS.has_feature("web"):
		exit_button.hide()

func _hide_new_game_if_unset() -> void:
	if get_game_scene_path().is_empty():
		new_game_button.hide()

func _hide_options_if_unset() -> void:
	if options_packed_scene == null:
		options_button.hide()

func _hide_credits_if_unset() -> void:
	if credits_packed_scene == null:
		credits_button.hide()

func _on_new_game_button_pressed() -> void:
	new_game()

func _on_options_button_pressed() -> void:
	_open_sub_menu(options_packed_scene)

func _on_credits_button_pressed() -> void:
	_open_sub_menu(credits_packed_scene)

func _on_exit_button_pressed() -> void:
	try_exit_game()

func _on_exit_confirmation_confirmed():
	exit_game()

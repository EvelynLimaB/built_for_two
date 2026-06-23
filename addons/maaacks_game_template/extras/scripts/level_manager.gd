class_name LevelManager
extends Node
## Manage chapter changes in games.
##
## A helper script to assign to a node in a scene.
## It works with a chapter loader and can open menus when players win or lose.
## It can either be assigned a starting chapter path or a scene lister.
## It can detect signals from chapters to change chapters in an open-world.
## With a scene lister, it will instead traverse through chapters linearly.

## Required reference to a chapter loader in the scene.
@export var chapter_loader : LevelLoader
## Optional path to a starting chapter scene.
## Required if there is no scene lister.
@export_file var starting_chapter_path : String
## Optional reference to a scene lister in the scene.
## Required if there is no starting chapter path.
@export var scene_lister : SceneLister
## Whether to load the starting chapter when ready.
@export var auto_load : bool = true
@export_group("Scenes")
## Path to a main menu scene.
## Will attempt to read from AppConfig if left empty.
@export_file("*.tscn") var main_menu_scene_path : String
## Optional path to an ending scene.
## Will attempt to read from AppConfig if left empty
@export_file("*.tscn") var ending_scene_path : String
## Optional screen to be shown after the game is won.
@export var game_won_scene : PackedScene
## Optional screen to be shown after the chapter is lost.
@export var chapter_lost_scene : PackedScene
## Optional screen to be shown after the chapter is won.
@export var chapter_won_scene : PackedScene

## Reference to the current chapter node.
var current_chapter : Node
var current_chapter_path : String : set = set_current_chapter_path
var checkpoint_chapter_path : String : set = set_checkpoint_chapter_path

func set_current_chapter_path(value : String) -> void:
	current_chapter_path = value

func set_checkpoint_chapter_path(value : String) -> void:
	checkpoint_chapter_path = value

func _try_connecting_signal_to_node(node : Node, signal_name : String, callable : Callable) -> void:
	if node.has_signal(signal_name) and not node.is_connected(signal_name, callable):
		node.connect(signal_name, callable)

func _try_connecting_signal_to_chapter(signal_name : String, callable : Callable) -> void:
	_try_connecting_signal_to_node(current_chapter, signal_name, callable)

func get_main_menu_scene_path() -> String:
	if main_menu_scene_path.is_empty():
		return AppConfig.main_menu_scene_path
	return main_menu_scene_path

func _load_main_menu() -> void:
	SceneLoader.load_scene(get_main_menu_scene_path())

func _find_in_scene_lister(chapter_path : String) -> int:
	if not scene_lister: return -1
	chapter_path = ResourceUID.ensure_path(chapter_path)
	return scene_lister.files.find(chapter_path)

func is_on_last_chapter() -> bool:
	var current_chapter_id = _find_in_scene_lister(current_chapter_path)
	return current_chapter_id > -1 and current_chapter_id == scene_lister.files.size() - 1

func get_relative_chapter_path(offset : int = 1) -> String:
	var current_chapter_id := _find_in_scene_lister(current_chapter_path)
	if current_chapter_id > -1:
		if current_chapter_id >= max(0, -(offset)) and current_chapter_id < scene_lister.files.size() - max(0, offset):
			current_chapter_id += offset
			return scene_lister.files[current_chapter_id]
	return ""

func get_next_chapter_path() -> String:
	return get_relative_chapter_path(1)

func get_prev_chapter_path() -> String:
	return get_relative_chapter_path(-1)

func get_ending_scene_path() -> String:
	if ending_scene_path.is_empty():
		return AppConfig.ending_scene_path
	return ending_scene_path

func _load_ending() -> void:
	if not get_ending_scene_path().is_empty():
		SceneLoader.load_scene(get_ending_scene_path())
	else:
		_load_main_menu()

func _on_chapter_lost() -> void:
	if chapter_lost_scene:
		var instance = chapter_lost_scene.instantiate()
		get_tree().current_scene.add_child(instance)
		_try_connecting_signal_to_node(instance, &"restart_pressed", _reload_chapter)
		_try_connecting_signal_to_node(instance, &"main_menu_pressed", _load_main_menu)
	else:
		_reload_chapter()

func get_checkpoint_chapter_path() -> String:
	if checkpoint_chapter_path.is_empty():
		if scene_lister:
			return scene_lister.files.front()
		if not starting_chapter_path.is_empty():
			return starting_chapter_path
	return checkpoint_chapter_path

func load_chapter(chapter_path : String) -> void:
	current_chapter_path = chapter_path
	chapter_loader.load_chapter(chapter_path)

func _load_checkpoint_chapter() -> void:
	load_chapter(get_checkpoint_chapter_path())

func _reload_chapter() -> void:
	load_chapter(current_chapter_path)

func _load_win_screen_or_ending() -> void:
	if game_won_scene:
		var instance = game_won_scene.instantiate()
		get_tree().current_scene.add_child(instance)
		_try_connecting_signal_to_node(instance, &"continue_pressed", _load_ending)
		_try_connecting_signal_to_node(instance, &"restart_pressed", _reload_chapter)
		_try_connecting_signal_to_node(instance, &"main_menu_pressed", _load_main_menu)
	else:
		_load_ending()

func _load_chapter_won_screen_or_checkpoint() -> void:
	if chapter_won_scene:
		var instance = chapter_won_scene.instantiate()
		get_tree().current_scene.add_child(instance)
		_try_connecting_signal_to_node(instance, &"continue_pressed", _load_checkpoint_chapter)
		_try_connecting_signal_to_node(instance, &"restart_pressed", _reload_chapter)
		_try_connecting_signal_to_node(instance, &"main_menu_pressed", _load_main_menu)
	else:
		_load_checkpoint_chapter()

func _on_chapter_won(next_chapter_path : String = ""):
	if next_chapter_path.is_empty():
		next_chapter_path = get_next_chapter_path()
	if next_chapter_path.is_empty():
		_load_win_screen_or_ending()
	else:
		checkpoint_chapter_path = next_chapter_path
		_load_chapter_won_screen_or_checkpoint()

func _on_chapter_changed(next_chapter_path : String):
	checkpoint_chapter_path = next_chapter_path
	_load_checkpoint_chapter()

func _connect_chapter_signals() -> void:
	_try_connecting_signal_to_chapter(&"chapter_lost", _on_chapter_lost)
	_try_connecting_signal_to_chapter(&"chapter_won", _on_chapter_won)
	_try_connecting_signal_to_chapter(&"chapter_changed", _on_chapter_changed)

func _on_chapter_loader_chapter_loaded() -> void:
	current_chapter = chapter_loader.current_chapter
	await current_chapter.ready
	_connect_chapter_signals()

func _on_chapter_loader_chapter_load_started() -> void:
	pass

func _on_chapter_loader_chapter_ready() -> void:
	pass

func _auto_load() -> void:
	if auto_load:
		_load_checkpoint_chapter()

func _ready() -> void:
	if Engine.is_editor_hint(): return
	chapter_loader.chapter_loaded.connect(_on_chapter_loader_chapter_loaded)
	chapter_loader.chapter_ready.connect(_on_chapter_loader_chapter_ready)
	chapter_loader.chapter_load_started.connect(_on_chapter_loader_chapter_load_started)
	_auto_load()

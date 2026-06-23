# level_select_menu.gd
extends Control

## Loads a simple ItemList node within a margin container. SceneLister updates
## the available scenes in the directory provided. Activating a level will update
## the GameState's current_level, and emit a signal. The main menu node will trigger
## a load action from that signal.

signal level_selected

@onready var level_buttons_container: ItemList = %LevelButtonsContainer
@onready var scene_lister: SceneLister = $SceneLister
var level_paths: Array[String] = []

func _ready() -> void:
	add_levels_to_container()

## A fresh level list is propagated into the ItemList, and the file names are cleaned
func add_levels_to_container() -> void:
	level_buttons_container.clear()
	level_paths.clear()
	
	# Get the game state and unlocked chapters
	var game_state := GameState.get_or_create_state()
	var unlocked = game_state.unlocked_chapters
	
	# Define all available chapter paths
	var all_chapter_paths = [
		"res://scenes/game_scene/levels/chapter_1.tscn",
		"res://scenes/game_scene/levels/chapter_2.tscn",
		"res://scenes/game_scene/levels/chapter_3.tscn",
	]
	
	# Add each chapter to the ItemList
	for i in range(all_chapter_paths.size()):
		var chapter_path = all_chapter_paths[i]
		var chapter_id = "ch" + str(i + 1)
		var is_unlocked = chapter_id in unlocked
		
		# Get clean display name
		var file_name = chapter_path.get_file()
		file_name = file_name.trim_suffix(".tscn")
		file_name = file_name.replace("_", " ")
		file_name = file_name.capitalize()
		
		# Add to ItemList
		var item_index = level_buttons_container.add_item(file_name)
		
		# Store the path for later use
		level_paths.append(chapter_path)
		
		# Disable locked chapters in the ItemList
		if not is_unlocked:
			level_buttons_container.set_item_disabled(item_index, true)
			level_buttons_container.set_item_tooltip(item_index, "This chapter is locked. Complete previous chapters to unlock it.")
		else:
			level_buttons_container.set_item_tooltip(item_index, "Click to play this chapter.")

func _on_level_buttons_container_item_activated(index: int) -> void:
	# Check if the selected item is disabled (locked)
	if level_buttons_container.is_item_disabled(index):
		return
	
	# Set the checkpoint level path in GameState
	var game_state = GameState.get_or_create_state()
	game_state.current_level_path = level_paths[index]
	game_state.checkpoint_level_path = level_paths[index]
	GlobalState.save()
	
	# Emit signal so main menu can load the level
	level_selected.emit()

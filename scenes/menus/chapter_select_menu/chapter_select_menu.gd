extends Control

signal chapter_selected

@onready var chapter_buttons_container: ItemList = %ChapterButtonsContainer
@onready var scene_lister: SceneLister = $SceneLister
var chapter_paths: Array[String] = []

func _ready() -> void:
	add_chapters_to_container()

func add_chapters_to_container() -> void:
	chapter_buttons_container.clear()
	chapter_paths.clear()
	
	var game_state := GameState.get_or_create_state()
	var unlocked = game_state.unlocked_chapters
	
	var all_chapter_paths = [
		"res://scenes/game_scene/chapters/chapter_1.tscn",
		"res://scenes/game_scene/chapters/chapter_2.tscn",
		"res://scenes/game_scene/chapters/chapter_3.tscn",
	]
	
	for i in range(all_chapter_paths.size()):
		var chapter_path = all_chapter_paths[i]
		var chapter_id = "ch" + str(i + 1)
		var is_unlocked = chapter_id in unlocked
		
		var file_name = chapter_path.get_file()
		file_name = file_name.trim_suffix(".tscn")
		file_name = file_name.replace("_", " ")
		file_name = file_name.capitalize()
		
		var item_index = chapter_buttons_container.add_item(file_name)
		chapter_paths.append(chapter_path)
		
		if not is_unlocked:
			chapter_buttons_container.set_item_disabled(item_index, true)
			chapter_buttons_container.set_item_tooltip(item_index, "This chapter is locked. Complete previous chapters to unlock it.")
		else:
			chapter_buttons_container.set_item_tooltip(item_index, "Click to play this chapter.")

func _on_chapter_buttons_container_item_activated(index: int) -> void:
	if chapter_buttons_container.is_item_disabled(index):
		return
	
	# ✅ Reset save slot when switching chapters to avoid conflicts
	Dialogic.Save.reset_slot()
	
	GameState.set_current_chapter_path(chapter_paths[index])
	GameState.set_checkpoint_chapter_path(chapter_paths[index])
	chapter_selected.emit()

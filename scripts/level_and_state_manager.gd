extends LevelManager

func set_current_chapter_path(value : String) -> void:
	super.set_current_chapter_path(value)
	GameState.set_current_chapter_path(value)

func set_checkpoint_chapter_path(value : String) -> void:
	super.set_checkpoint_chapter_path(value)
	GameState.set_checkpoint_chapter_path(value)

func get_checkpoint_chapter_path() -> String:
	var state_chapter_path := GameState.get_checkpoint_chapter_path()
	if not state_chapter_path.is_empty():
		return state_chapter_path
	return super.get_checkpoint_chapter_path()

func on_timeline_ended(chapter_id: String, next_chapter: String) -> void:
	var game_state = GameState.get_or_create_state()
	game_state.unlock_chapter(next_chapter)
	# Then load next chapter or show menu

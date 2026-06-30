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
	# ✅ NOTE: This is a template method that may or may not be called.
	# The main timeline logic is handled in chapter.gd's _on_timeline_ended().
	# This method exists for subclasses or external managers to override.
	
	var game_state = GameState.get_or_create_state()
	game_state.unlock_chapter(next_chapter)
	
	# ✅ If implemented by a subclass, load the next chapter or show menu here
	# For now, it's a no-op since chapter.gd handles the full flow independently
	pass

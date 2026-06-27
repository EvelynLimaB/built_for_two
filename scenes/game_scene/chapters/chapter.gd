extends Node

signal level_won

## Set this in the editor for each chapter
@export var timeline_path: String
@export var next_chapter_id: String

## ============================================================================
## LIFECYCLE
## ============================================================================

func _ready():
	# ✅ Validate timeline_path
	if timeline_path.is_empty():
		push_error("❌ timeline_path is empty! Chapter cannot start.")
		return
	
	# ✅ Disable autosave during loading to prevent state corruption
	Dialogic.Save.autosave_enabled = false
	
	# ✅ Connect signals
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	
	# ✅ Try to load save first
	var save_loaded_successfully = false
	if SaveManager.has_save():
		save_loaded_successfully = SaveManager.load_game()
		
		if not save_loaded_successfully:
			push_warning("⚠️ Save corrupted! Deleting slot...")
			SaveManager.delete_save()
	
	# ✅ ONLY start the timeline if we didn't just load a saved session
	if not save_loaded_successfully:
		Dialogic.start(timeline_path)
	
	# ✅ Reactivate autosave after the timeline is stable
	call_deferred("_enable_autosave")

## ============================================================================
## AUTOSAVE CONTROL
## ============================================================================

func _enable_autosave():
	Dialogic.Save.autosave_enabled = true
	print("✅ Autosave re-enabled after timeline start")

## ============================================================================
## SIGNAL HANDLERS
## ============================================================================

func _on_dialogic_signal(argument: String):
	match argument:
		"save_game":
			# ✅ Save via signal (safe moment)
			var extra_info = SaveManager.create_extra_info()
			SaveManager.save_game(SaveManager.DEFAULT_SLOT, extra_info)
		"unlock_chapter":
			# ✅ Unlock next chapter via signal
			GameState.unlock_chapter(next_chapter_id)
		_:
			pass

func _on_timeline_ended():
	# ✅ Save at the end of the timeline (safety net)
	var extra_info = SaveManager.create_extra_info()
	SaveManager.save_game(SaveManager.DEFAULT_SLOT, extra_info)
	
	# ✅ Unlock next chapter
	GameState.unlock_chapter(next_chapter_id)
	
	# ✅ Emit signal to LevelManager
	level_won.emit()

## ============================================================================
## CLEANUP
## ============================================================================

func _exit_tree():
	# Note: In Godot 4, freeing an object automatically disconnects its signals.
	# However, since Dialogic is a singleton (Autoload), manually disconnecting 
	# here is a great practice to completely guarantee no memory/signal leaks.
	if Dialogic.signal_event.is_connected(_on_dialogic_signal):
		Dialogic.signal_event.disconnect(_on_dialogic_signal)
	if Dialogic.timeline_ended.is_connected(_on_timeline_ended):
		Dialogic.timeline_ended.disconnect(_on_timeline_ended)

extends Node

signal level_won

## Set this in the editor for each chapter
@export var timeline_path: String
@export var next_chapter_id: String

func _ready():
	# ✅ Disable autosave completely - we'll use manual signals
	Dialogic.Save.autosave_enabled = false
	
	# ✅ Connect to Dialogic's signal event system
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	var save_slot: String = Dialogic.Save.get_default_slot()
	
	if Dialogic.Save.has_slot(save_slot):
		Dialogic.start(timeline_path)
		var result = Dialogic.Save.load(save_slot)
		if result != OK:
			push_warning("⚠️ Save file corrupted! Starting fresh...")
			Dialogic.Save.reset_slot()
			Dialogic.start(timeline_path)
	else:
		Dialogic.start(timeline_path)
	
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_dialogic_signal(argument: String):
	# ✅ Save when the timeline emits a save signal
	if argument == "save_game":
		var result = Dialogic.Save.save("Default")
		if result == OK:
			print("✅ Game saved via signal")
		else:
			push_error("❌ Save failed via signal")

func _on_timeline_ended():
	# ✅ Save on timeline end as a safety net
	Dialogic.Save.save("Default")
	GameState.unlock_chapter(next_chapter_id)
	level_won.emit()

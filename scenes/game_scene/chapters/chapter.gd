extends Node

signal level_won

## Set this in the editor for each chapter
@export var timeline_path: String
@export var next_chapter_id: String

func _ready():
	var save_slot = Dialogic.Save.get_default_slot()
	
	if Dialogic.Save.has_slot(save_slot):
		# Restore from save
		Dialogic.start(timeline_path)
		Dialogic.Save.load(save_slot)
	else:
		# Start fresh
		Dialogic.start(timeline_path)
	
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_timeline_ended():
		GameState.unlock_chapter("ch2")
		print("ch2 unlocked")
		level_won.emit()

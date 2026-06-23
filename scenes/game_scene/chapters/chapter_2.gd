extends Node

signal level_won(level_path : String)
@warning_ignore("unused_signal")
signal level_changed(level_path : String)

## Optional path to the next level if using an open world level system.
@export_file("*.tscn") var next_level_path : String

func _ready():
	Dialogic.start("res://timelines/ch2_master.dtl")
	Dialogic.timeline_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended():
	# Unlock next chapter
	var game_state = GameState.get_or_create_state()
	game_state.unlock_chapter("ch3")
	GlobalState.save()
	# Tell LevelManager we're done
	level_won.emit(next_level_path)

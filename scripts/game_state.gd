# game_state.gd
extends Resource
class_name GameState

const STATE_NAME : String = "GameState"
const FILE_PATH = "res://scripts/game_state.gd"

@export var chapter_states : Dictionary = {}
@export var current_chapter_path : String
@export var checkpoint_chapter_path : String
@export var total_games_played : int
@export var play_time : int
@export var total_time : int
@export var unlocked_chapters : Array[String] = ["ch1"]  # ← ADD THIS


func unlock_chapter(chapter_id: String) -> void:
	if not chapter_id in unlocked_chapters:
		unlocked_chapters.append(chapter_id)
		GlobalState.save()

static func get_chapter_state(chapter_state_key : String) -> LevelState:
	if not has_game_state(): 
		return
	var game_state := get_or_create_state()
	if chapter_state_key.is_empty() : return
	if chapter_state_key in game_state.chapter_states:
		return game_state.chapter_states[chapter_state_key] 
	else:
		var new_chapter_state := LevelState.new()
		game_state.chapter_states[chapter_state_key] = new_chapter_state
		GlobalState.save()
		return new_chapter_state

static func has_game_state() -> bool:
	return GlobalState.has_state(STATE_NAME)

static func get_or_create_state() -> GameState:
	return GlobalState.get_or_create_state(STATE_NAME, FILE_PATH)

static func get_current_chapter_path() -> String:
	if not has_game_state(): 
		return ""
	var game_state := get_or_create_state()
	return game_state.current_chapter_path

static func get_checkpoint_chapter_path() -> String:
	if not has_game_state(): 
		return ""
	var game_state := get_or_create_state()
	return game_state.checkpoint_chapter_path

static func get_chapters_reached() -> int:
	if not has_game_state(): 
		return 0
	var game_state := get_or_create_state()
	return game_state.chapter_states.size()

static func set_checkpoint_chapter_path(chapter_path : String) -> void:
	var game_state := get_or_create_state()
	game_state.checkpoint_chapter_path = chapter_path
	get_chapter_state(chapter_path)
	GlobalState.save()

static func set_current_chapter_path(chapter_path : String) -> void:
	var game_state := get_or_create_state()
	game_state.current_chapter_path = chapter_path
	GlobalState.save()

static func start_game() -> void:
	var game_state := get_or_create_state()
	game_state.total_games_played += 1
	GlobalState.save()

static func continue_game() -> void:
	var game_state := get_or_create_state()
	game_state.current_chapter_path = game_state.checkpoint_chapter_path
	GlobalState.save()

static func reset() -> void:
	var game_state := get_or_create_state()
	game_state.chapter_states = {}
	game_state.current_chapter_path = ""
	game_state.checkpoint_chapter_path = ""
	game_state.play_time = 0
	game_state.total_time = 0
	GlobalState.save()

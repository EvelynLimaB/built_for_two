# game_state.gd
extends Resource
class_name GameState

const STATE_NAME : String = "GameState"
const FILE_PATH : String = "res://scripts/game_state.gd"

# --- Data ---
@export var chapter_states : Dictionary = {}            # {chapter_path: LevelState}
@export var current_chapter_path : String = ""         # Path to the chapter being played
@export var checkpoint_chapter_path : String = ""      # Path to the last checkpoint
@export var unlocked_chapters : Array[String] = ["ch1"] # Chapter IDs (ch1, ch2, ch3)
@export var total_games_played : int = 0
@export var play_time : int = 0
@export var total_time : int = 0

# --- Core Accessors ---
static func get_or_create_state() -> GameState:
	return GlobalState.get_or_create_state(STATE_NAME, FILE_PATH)

static func has_state() -> bool:
	return GlobalState.has_state(STATE_NAME)

static func save() -> void:
	GlobalState.save()

# --- Chapter State ---
static func get_chapter_state(chapter_path: String) -> LevelState:
	if chapter_path.is_empty():
		return null
	
	var game_state := get_or_create_state()
	if game_state.chapter_states.has(chapter_path):
		return game_state.chapter_states[chapter_path]
	
	var new_state := LevelState.new()
	game_state.chapter_states[chapter_path] = new_state
	save()
	return new_state

static func mark_chapter_completed(chapter_path: String) -> void:
	var state := get_chapter_state(chapter_path)
	if state:
		state.completed = true
		save()

# --- Unlock System ---
static func unlock_chapter(chapter_id: String) -> void:
	var game_state := get_or_create_state()
	if not game_state.unlocked_chapters.has(chapter_id):
		game_state.unlocked_chapters.append(chapter_id)
		save()

static func is_chapter_unlocked(chapter_id: String) -> bool:
	var game_state := get_or_create_state()
	return game_state.unlocked_chapters.has(chapter_id)

# --- Path Management ---
static func set_current_chapter_path(path: String) -> void:
	var game_state := get_or_create_state()
	game_state.current_chapter_path = path
	save()

static func get_current_chapter_path() -> String:
	var game_state := get_or_create_state()
	return game_state.current_chapter_path

static func set_checkpoint_chapter_path(path: String) -> void:
	var game_state := get_or_create_state()
	game_state.checkpoint_chapter_path = path
	save()

static func get_checkpoint_chapter_path() -> String:
	var game_state := get_or_create_state()
	return game_state.checkpoint_chapter_path

# --- Game Flow ---
static func start_game() -> void:
	var game_state := get_or_create_state()
	game_state.total_games_played += 1
	
	# Default to chapter 1 if no chapter is set
	if game_state.current_chapter_path.is_empty():
		game_state.current_chapter_path = "res://scenes/game_scene/levels/chapter_1.tscn"
		if not game_state.unlocked_chapters.has("ch1"):
			game_state.unlocked_chapters.append("ch1")
	
	save()

static func continue_game() -> void:
	var game_state := get_or_create_state()
	
	# Use checkpoint if available, otherwise use current chapter
	if not game_state.checkpoint_chapter_path.is_empty():
		game_state.current_chapter_path = game_state.checkpoint_chapter_path
	elif game_state.current_chapter_path.is_empty():
		# Fallback to chapter 1
		game_state.current_chapter_path = "res://scenes/game_scene/levels/chapter_1.tscn"
		if not game_state.unlocked_chapters.has("ch1"):
			game_state.unlocked_chapters.append("ch1")
	
	save()

static func reset_game() -> void:
	var game_state := get_or_create_state()
	game_state.chapter_states.clear()
	game_state.current_chapter_path = "res://scenes/game_scene/levels/chapter_1.tscn"
	game_state.checkpoint_chapter_path = ""
	game_state.unlocked_chapters = ["ch1"]
	game_state.play_time = 0
	game_state.total_time = 0
	game_state.total_games_played = 0
	save()

# --- UI Helpers ---
static func get_chapters_reached() -> int:
	var game_state := get_or_create_state()
	return game_state.unlocked_chapters.size()

static func get_total_chapters() -> int:
	return 3  # Total chapters in the game (can also be dynamic)

static func get_unlocked_chapters() -> Array[String]:
	var game_state := get_or_create_state()
	return game_state.unlocked_chapters.duplicate()

static func get_progress_percentage() -> float:
	return float(get_chapters_reached()) / float(get_total_chapters())

# main_menu_with_animations.gd
extends MainMenu

## ============================================================================
## GAME LOADING
## ============================================================================

## Loads the game scene. If start_new_game is true, increments total_games_played.
func load_game_scene(start_new_game: bool = false) -> void:
	if start_new_game:
		GameState.start_game()
	super.load_game_scene()

## Loads the game scene without starting a new game (for Continue and Chapter Select).
func load_continue_scene() -> void:
	super.load_game_scene()

## ============================================================================
## GAME FLOW FUNCTIONS
## ============================================================================

## Handles "New Game" button press - shows confirmation if a game is in progress.
func new_game() -> void:
	if confirm_new_game and continue_game_button.visible:
		new_game_confirmation.show()
	else:
		GameState.reset()
		Dialogic.Save.reset_slot()
		load_game_scene(true)

## ============================================================================
## INTRO ANIMATION
## ============================================================================

## Completes the intro animation and opens the main menu.
func intro_done() -> void:
	animation_state_machine.travel("OpenMainMenu")

## Returns true if the intro animation is currently playing.
func _is_in_intro() -> bool:
	return animation_state_machine.get_current_node() == "Intro"

## Checks if an input event should skip the intro animation.
func _event_skips_intro(event : InputEvent) -> bool:
	return event.is_action_released("ui_accept") or \
		   event.is_action_released("ui_select") or \
		   event.is_action_released("ui_cancel") or \
		   _event_is_mouse_button_released(event)

## ============================================================================
## SUB-MENU MANAGEMENT
## ============================================================================

## Opens a sub-menu with animation.
func _open_sub_menu(menu : PackedScene) -> Node:
	animation_state_machine.travel("OpenSubMenu")
	return super._open_sub_menu(menu)

## Closes the current sub-menu with animation.
func _close_sub_menu() -> void:
	super._close_sub_menu()
	animation_state_machine.travel("OpenMainMenu")

## ============================================================================
## INPUT HANDLING
## ============================================================================

## Handles input events - skips intro if active, otherwise passes to parent.
func _input(event : InputEvent) -> void:
	if _is_in_intro() and _event_skips_intro(event):
		intro_done()
		return
	super._input(event)

## ============================================================================
## UI VISIBILITY UPDATES
## ============================================================================

## Shows the Chapter Select button if there are unlocked chapters.
func _show_chapter_select_if_set() -> void: 
	if chapter_select_packed_scene == null:
		return
	if GameState.get_chapters_reached() <= 1:
		return
	chapter_select_button.show()

## Shows the Continue button if a Dialogic save exists.
func _show_continue_if_set() -> void:
	var slot := Dialogic.Save.get_default_slot()
	if not Dialogic.Save.has_slot(slot):
		return
	continue_game_button.show()

## ============================================================================
## DIALOGIC SAVE MANAGEMENT
## ============================================================================

## Restores a Dialogic save from the specified slot.
## Call this AFTER loading the game scene and the chapter script's _ready().
func _restore_dialogic_save(slot: String) -> void:
	if Dialogic.Save.has_slot(slot):
		Dialogic.Save.load(slot)

## ============================================================================
## READY
## ============================================================================

## Initializes the menu, shows/hides buttons, and sets up animation.
func _ready() -> void:
	super._ready()
	_show_chapter_select_if_set()
	_show_continue_if_set()
	animation_state_machine = $MenuAnimationTree.get("parameters/playback")

## ============================================================================
## SIGNAL HANDLERS
## ============================================================================

## Handles "Continue Game" button press - loads the checkpoint and game scene.
func _on_continue_game_button_pressed() -> void:
	GameState.continue_game()
	load_continue_scene()

## Handles "New Game" confirmation dialog confirmation.
func _on_new_game_confirmation_confirmed() -> void:
	GameState.reset()
	Dialogic.Save.reset_slot()
	load_game_scene(true)

## Handles "Chapter Select" button press - opens the chapter select sub-menu.
func _on_chapter_select_button_pressed() -> void:
	var chapter_select_scene := _open_sub_menu(chapter_select_packed_scene)
	if chapter_select_scene.has_signal("chapter_selected"):
		chapter_select_scene.connect("chapter_selected", load_continue_scene)

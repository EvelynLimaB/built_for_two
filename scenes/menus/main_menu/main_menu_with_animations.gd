extends MainMenu

## ============================================================================
## GAME LOADING
## ============================================================================

func load_game_scene(start_new_game: bool = false) -> void:
	if start_new_game:
		GameState.start_game()
		# ✅ Reset save slot on new game
		Dialogic.Save.reset_slot()
	super.load_game_scene()

func load_continue_scene() -> void:
	super.load_game_scene()

## ============================================================================
## GAME FLOW
## ============================================================================

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

func intro_done() -> void:
	animation_state_machine.travel("OpenMainMenu")

func _is_in_intro() -> bool:
	return animation_state_machine.get_current_node() == "Intro"

func _event_skips_intro(event : InputEvent) -> bool:
	return event.is_action_released("ui_accept") or \
		   event.is_action_released("ui_select") or \
		   event.is_action_released("ui_cancel") or \
		   _event_is_mouse_button_released(event)

## ============================================================================
## SUB-MENU MANAGEMENT
## ============================================================================

func _open_sub_menu(menu : PackedScene) -> Node:
	animation_state_machine.travel("OpenSubMenu")
	return super._open_sub_menu(menu)

func _close_sub_menu() -> void:
	super._close_sub_menu()
	animation_state_machine.travel("OpenMainMenu")

## ============================================================================
## INPUT HANDLING
## ============================================================================

func _input(event : InputEvent) -> void:
	if _is_in_intro() and _event_skips_intro(event):
		intro_done()
		return
	super._input(event)

## ============================================================================
## UI VISIBILITY
## ============================================================================

func _show_chapter_select_if_set() -> void: 
	if chapter_select_packed_scene == null:
		return
	if GameState.get_chapters_reached() <= 1:
		return
	chapter_select_button.show()

func _show_continue_if_set() -> void:
	var slot := Dialogic.Save.get_default_slot()
	if not Dialogic.Save.has_slot(slot):
		return
	continue_game_button.show()

## ============================================================================
## READY
## ============================================================================

func _ready() -> void:
	super._ready()
	_show_chapter_select_if_set()
	_show_continue_if_set()
	animation_state_machine = $MenuAnimationTree.get("parameters/playback")
	var slots = SaveManager.get_all_slots()
	for slot in slots:
		var info = SaveManager.get_slot_info(slot)
		print("Slot: ", slot, " - ", info.get("date", "Sem data"))
		# Aqui você criaria botões para cada slot

## ============================================================================
## SIGNAL HANDLERS
## ============================================================================

func _on_continue_game_button_pressed() -> void:
	GameState.continue_game()
	load_continue_scene()

func _on_new_game_confirmation_confirmed() -> void:
	GameState.reset()
	Dialogic.Save.reset_slot()
	load_game_scene(true)

func _on_chapter_select_button_pressed() -> void:
	var chapter_select_scene := _open_sub_menu(chapter_select_packed_scene)
	if chapter_select_scene.has_signal("chapter_selected"):
		chapter_select_scene.connect("chapter_selected", load_continue_scene)

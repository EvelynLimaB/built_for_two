extends MainMenu
## Main menu extension that adds options.
## The scene adds a 'Continue' button if a game is in progress.

func load_game_scene() -> void:
	GameState.start_game()
	super.load_game_scene()

func new_game() -> void:
	if confirm_new_game and continue_game_button.visible:
		new_game_confirmation.show()
	else:
		GameState.reset()
		load_game_scene()

func _add_chapter_select_if_set() -> void: 
	if chapter_select_packed_scene == null: return
	if GameState.get_chapters_reached() <= 1 : return
	chapter_select_button.show()

func _show_continue_if_set() -> void:
	if GameState.get_current_chapter_path().is_empty(): return
	continue_game_button.show()

func _ready() -> void:
	super._ready()
	_add_chapter_select_if_set()
	_show_continue_if_set()

func _on_continue_game_button_pressed() -> void:
	GameState.continue_game()
	load_game_scene()

func _on_chapter_select_button_pressed() -> void:
	var chapter_select_scene := _open_sub_menu(chapter_select_packed_scene)
	if chapter_select_scene.has_signal("chapter_selected"):
		chapter_select_scene.connect("chapter_selected", load_game_scene)

func _on_new_game_confirmation_confirmed() -> void:
	GameState.reset()
	load_game_scene()

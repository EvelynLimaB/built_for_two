extends Control
class_name SaveGallery

# Signal to tell the parent pause menu to close this gallery
signal close_menu_requested

@export var save_slot_scene: PackedScene
@onready var grid = $ScrollContainer/GridContainer

enum Mode { SAVE, LOAD }
var current_mode: Mode = Mode.SAVE


func _ready() -> void:
	if save_slot_scene == null:
		push_error("SaveGallery: save_slot_scene is not assigned!")
		return
	populate_gallery()


func populate_gallery() -> void:
	# Safely clear the grid before repopulating
	if grid == null:
		push_error("SaveGallery: Grid node not found!")
		return

	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()

	var existing_slots = Dialogic.Save.get_slot_names()
	var total_slots = 12

	for i in range(1, total_slots + 1):
		var slot_id = "slot_" + str(i)
		var slot_instance = save_slot_scene.instantiate()
		grid.add_child(slot_instance)

		var has_data = existing_slots.has(slot_id)
		slot_instance.setup(slot_id, not has_data)
		slot_instance.slot_selected.connect(_on_slot_clicked)


func _on_slot_clicked(slot_name: String) -> void:
	if current_mode == Mode.SAVE:
		# Save the game with extra info (chapter, date, etc.)
		SaveManager.save_game(slot_name, SaveManager.create_extra_info())
		# Refresh the gallery to show the new save
		populate_gallery()

	elif current_mode == Mode.LOAD:
		if Dialogic.Save.has_slot(slot_name):
			# Try to load the game. SaveManager.load_game() returns true on success.
			var success = SaveManager.load_game(slot_name)
			if success:
				# Close the gallery – the pause menu will then hide itself
				close_menu_requested.emit()
			else:
				# Loading failed – you might want to show an error message
				push_warning("SaveGallery: Failed to load slot '%s'" % slot_name)


## Switch between Save and Load modes (useful if you add a toggle button)
func set_mode(mode: Mode) -> void:
	current_mode = mode
	# Optionally update UI text to reflect the mode

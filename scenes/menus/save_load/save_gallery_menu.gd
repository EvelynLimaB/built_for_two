extends Control 

# ✅ NEW: Signal to tell the parent Pause Menu to close
signal close_menu_requested 

@export var save_slot_scene: PackedScene
@onready var grid = $ScrollContainer/GridContainer

func _ready():
	if save_slot_scene == null:
		push_error("❌ save_slot_scene is not assigned in the editor!")
		return

enum Mode { SAVE, LOAD }
var current_mode: Mode = Mode.SAVE

func _ready():
	populate_gallery()

func populate_gallery():
	# ✅ BUG 2 FIX: Safely clear the grid before repopulating
	for child in grid.get_children():
		grid.remove_child(child) # Instantly removes from the UI grid
		child.queue_free()       # Safely deletes from memory
		
	var existing_slots = Dialogic.Save.get_slot_names()
	var total_slots = 12 
	
	for i in range(1, total_slots + 1):
		var slot_id = "slot_" + str(i)
		
		var slot_instance = save_slot_scene.instantiate()
		grid.add_child(slot_instance)
		
		var has_data = existing_slots.has(slot_id)
		slot_instance.setup(slot_id, not has_data)
		slot_instance.slot_selected.connect(_on_slot_clicked)

func _on_slot_clicked(slot_name: String):
	if current_mode == Mode.SAVE:
		SaveManager.save_game(slot_name, SaveManager.create_extra_info())
		populate_gallery() # Refresh UI to show new save
		
	elif current_mode == Mode.LOAD:
		if Dialogic.Save.has_slot(slot_name):
			var loaded = SaveManager.load_game(slot_name)
			if loaded:
				close_menu_requested.emit()

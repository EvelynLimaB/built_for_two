extends Button

signal slot_selected(slot_name: String)

@export var slot_name: String = ""
@onready var thumbnail_rect = $MarginContainer/VBoxContainer/TextureRect
@onready var info_label = $MarginContainer/VBoxContainer/InfoLabel

func _ready():
	# When this button is clicked, emit the signal with its slot name
	pressed.connect(func(): slot_selected.emit(slot_name))

func setup(name_of_slot: String, is_empty: bool):
	slot_name = name_of_slot
	
	if is_empty:
		info_label.text = "Empty Slot"
		# Optional: Set a placeholder image for empty slots
		# thumbnail_rect.texture = preload("res://assets/empty_slot.png")
	else:
		# 1. Get the Extra Info Dictionary (Date, Chapter, etc.)
		var info = Dialogic.Save.get_slot_info(slot_name)
		info_label.text = info.get("date", "Unknown Date") 
		
		# 2. Get the Thumbnail directly as a Texture (Dialogic 2 API)
		var texture: ImageTexture = Dialogic.Save.get_slot_thumbnail(slot_name)
		
		if texture != null:
			thumbnail_rect.texture = texture
			thumbnail_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			thumbnail_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED

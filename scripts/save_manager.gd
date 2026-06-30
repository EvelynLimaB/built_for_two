extends Node

## Nome do slot padrão (pode ser alterado nas configurações do Dialogic)
const DEFAULT_SLOT := "default"

## Sinal emitido quando um save é concluído
signal game_saved(slot_name: String, is_autosave: bool)

## Sinal emitido quando um load é concluído
signal game_loaded(slot_name: String)

func _ready():
	# Configurar autosave (sempre salva no slot padrão)
	Dialogic.Save.autosave_enabled = true
	Dialogic.Save.saved.connect(_on_saved)
 
## Salva o jogo em um slot específico
func save_game(slot_name: String = DEFAULT_SLOT, extra_info: Dictionary = {}):
	var result = Dialogic.Save.save(
		slot_name,
		false, 
		Dialogic.Save.ThumbnailMode.STORE_ONLY, # ✅ Usa a imagem pré-capturada do pause menu
		extra_info
	)
	if result == OK:
		print("✅ Save concluído em: ", slot_name)
		game_saved.emit(slot_name, false)
	else:
		push_error("❌ Falha ao salvar em: ", slot_name)

## Carrega o jogo de um slot específico
func load_game(slot_name: String = DEFAULT_SLOT) -> bool:
	if not Dialogic.Save.has_slot(slot_name):
		print("ℹ️ Nenhum save encontrado em: ", slot_name)
		return false
	
	var result = Dialogic.Save.load(slot_name)
	if result == OK:
		print("✅ Jogo carregado de: ", slot_name)
		game_loaded.emit(slot_name)
		return true
	else:
		push_error("❌ Falha ao carregar save de: ", slot_name)
		# ✅ Back up the corrupted save instead of deleting it
		_backup_corrupted_save(slot_name)
		return false

## Verifica se existe um save em um slot
func has_save(slot_name: String = DEFAULT_SLOT) -> bool:
	return Dialogic.Save.has_slot(slot_name)

## Deleta um save de um slot específico
func delete_save(slot_name: String = DEFAULT_SLOT):
	if Dialogic.Save.has_slot(slot_name):
		Dialogic.Save.delete_slot(slot_name)
		print("🗑️ Save deletado: ", slot_name)

## Retorna informações extras de um slot (para exibir no menu)
func get_slot_info(slot_name: String = DEFAULT_SLOT) -> Dictionary:
	if not has_save(slot_name):
		return {}
	return Dialogic.Save.get_slot_info(slot_name)

## Cria um dicionário com informações extras para salvar
func create_extra_info() -> Dictionary:
	return {
		"date": Time.get_datetime_string_from_system(false, true),
		"chapter": GameState.get_current_chapter_path()
	}

## Lista todos os slots disponíveis (pastas em user://)
func get_all_slots() -> Array[String]:
	var slots: Array[String] = []
	var dir = DirAccess.open("user://")
	if dir:
		for folder in dir.get_directories():
			# Verifica se é um slot do Dialogic (contém state.txt)
			var state_path = "user://" + folder + "/state.txt"
			if FileAccess.file_exists(state_path):
				slots.append(folder)
	return slots

## Handler para autosave
func _on_saved(slot_name: String, is_autosave: bool):
	if is_autosave:
		print("🔄 Autosave realizado em: ", slot_name)
	game_saved.emit(slot_name, is_autosave)

## Reset completo de um slot (para New Game)
func reset_slot(slot_name: String = DEFAULT_SLOT):
	delete_save(slot_name)
	# Se for o slot padrão, também reseta o estado interno do Dialogic
	if slot_name == DEFAULT_SLOT:
		Dialogic.Save.reset_slot()
	print("🔄 Slot resetado: ", slot_name)

## ✅ Backup corrupted saves instead of losing them forever
func _backup_corrupted_save(slot_name: String) -> void:
	var timestamp = Time.get_datetime_string_from_system(false, true).replace(":", "-")
	var backup_slot_name = slot_name + "_CORRUPTED_" + timestamp
	
	# Dialogic save files are stored in user:// - we manually copy the slot folder
	var source_path = "user://" + slot_name
	var backup_path = "user://" + backup_slot_name
	
	var dir = DirAccess.open("user://")
	if dir and dir.dir_exists(source_path):
		dir.rename(source_path, backup_path)
		print("💾 Corrupted save backed up to: ", backup_slot_name)
	else:
		push_warning("⚠️ Could not backup corrupted save (directory issue)")
	
	# Now delete the corrupted original slot via Dialogic API as fallback
	if Dialogic.Save.has_slot(slot_name):
		Dialogic.Save.delete_slot(slot_name)

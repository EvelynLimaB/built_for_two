@tool
class_name LevelLoader
extends Node
## Loads scenes into a container.

signal chapter_load_started
signal chapter_loaded
signal chapter_ready

## Container where the chapter instance will be added.
@export var chapter_container : Node
## Optional reference to a loading screen in the scene.
@export var chapter_loading_screen : LoadingScreen
@export_group("Debugging")
@export var current_chapter : Node

var current_chapter_path : String
var is_loading : bool = false

func _attach_chapter(chapter_resource : Resource):
	assert(chapter_container != null, "chapter_container is null")
	var instance = chapter_resource.instantiate()
	chapter_container.call_deferred("add_child", instance)
	return instance

func load_chapter(chapter_path : String):
	if is_loading : return
	if is_instance_valid(current_chapter):
		current_chapter.queue_free()
		await current_chapter.tree_exited
		current_chapter = null
	current_chapter_path = chapter_path
	is_loading = true
	SceneLoader.load_scene(current_chapter_path, true)
	if chapter_loading_screen:
		chapter_loading_screen.reset()
	chapter_load_started.emit()
	await SceneLoader.scene_loaded
	is_loading = false
	current_chapter = _attach_chapter(SceneLoader.get_resource())
	if chapter_loading_screen:
		chapter_loading_screen.close()
	chapter_loaded.emit()
	await current_chapter.ready
	chapter_ready.emit()

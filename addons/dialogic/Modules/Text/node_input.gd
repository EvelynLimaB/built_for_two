class_name DialogicNode_Input
extends Control

## A node that handles mouse input. This allows limiting mouse input to a
## specific region and avoiding conflicts with other UI elements.
## If no Input node is used, the input subsystem will handle mouse input instead.

func _ready() -> void:
	add_to_group('dialogic_input')
	gui_input.connect(_on_gui_input)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_auto"):
		Dialogic.Inputs.auto_advance.enabled_until_user_input = not Dialogic.Inputs.auto_advance.enabled_until_user_input
	
	if event.is_action_pressed("toggle_skip"):
		Dialogic.Inputs.auto_skip.enabled = not Dialogic.Inputs.auto_skip.enabled
	if Input.is_action_pressed(ProjectSettings.get_setting('dialogic/text/input_action', 'dialogic_default_action')):
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_gui_input(event:InputEvent) -> void:
	DialogicUtil.autoload().Inputs.handle_node_gui_input(event)

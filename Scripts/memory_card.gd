extends Node2D

var can_control = true
var is_open = false
var matched = false


func _on_control_gui_input(event: InputEvent) -> void:

	if !can_control:
		return

	if matched:
		return

	if is_open:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			get_parent().card_selected(self)

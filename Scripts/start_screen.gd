extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	Global.Score = 0 
	Global.robot_score = 0
	Global.tempScore = 0
	Global.matchScore = 0 
	Global.robot_matchScore = 0
	Global.switched = false


func _on_help_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/help_screen.tscn")

func _on_end_button_pressed() -> void:
	get_tree().quit()

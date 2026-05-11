extends CanvasLayer
@onready var dialogue_box = $Panel
@onready var dialogue_text = $Panel/Label

var full_text := ""
var current_index := 0
var typing_speed := 0.03
var typing_timer := 0.0
var typing := false

func _ready():
	dialogue_box.visible = false

func start_dialogue(text: String):
	full_text = text
	current_index = 0
	typing_timer = 0.0
	dialogue_text.text = ""
	dialogue_box.visible = true
	typing = true

func _process(delta):
	if typing:
		typing_timer += delta

		if typing_timer >= typing_speed:
			typing_timer = 0.0
			current_index += 1
			dialogue_text.text = full_text.substr(0, current_index)

			if current_index >= full_text.length():
				typing = false

		await get_tree().create_timer(2).timeout
		dialogue_box.visible = false
		if get_tree()!=null:
			get_tree().paused = false

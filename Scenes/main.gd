extends Node2D

var count=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if count==500:
		Global.Score=10
		count+=1
	elif count==100:
		Global.Score=5
	elif count==200:
		Global.Score=6
	elif count==300:
		Global.Score=7
	elif count==500:
		Global.Score=20
	#print(count)
	if Global.Score==10:
		Robot_break()
		
	elif Global.Score==5:
		print(Global.Score)
		Robot_mad(Global.Score)
		
	elif Global.Score==6:
		print(Global.Score)
		Robot_mad(Global.Score)
		
	elif Global.Score==7:
		print(Global.Score)
		Robot_mad(Global.Score)
	elif Global.Score==20:
		get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")
	else:
		pass
	Global.Score=11
	count+=1
func Robot_mad(score):
	
	$CanvasLayer.visible=true
	#await get_tree().create_timer(0.5).timeout
	get_tree().paused = true
	$dialogue_box.process_mode = Node.PROCESS_MODE_ALWAYS
	#print("robot mad")
	if score==5:
		$dialogue_box.start_dialogue("Robot: Human is winning")
	elif score==6:
		$dialogue_box.start_dialogue("Robot: Human capacity is low, robot must win")
	elif score==7:
		$CanvasLayer2.visible=true
		$CanvasLayer.visible=false
		$dialogue_box.start_dialogue("Robot: Unexpected output from human...EXTERMINATE")
		
		
	
func Robot_break():
	$dialogue_box.start_dialogue("Robot: EXTERMINATE, EXTERMINATE, EXTERMINATE")
	print("robot break")
	$CanvasLayer3.visible=true

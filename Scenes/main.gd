extends Node2D

var count=2
# Called when the node enters the scene tree for the first time.

var curr_minigame = "match"

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if count==500:
		#Global.Score=10
		#count+=1
	#elif count==100:
		#Global.Score=5
	#elif count==200:
		#Global.Score=6
	#elif count==300:
		#Global.Score=7
	#elif count==500:
		#Global.Score=20
	#print(count)
	if Global.Score==10 and count==1:
		await get_tree().create_timer(0.3).timeout
		count=2
		Robot_break()
		#switch game
		switch_minigame()
		
	elif Global.Score==2 and count==2:
		await get_tree().create_timer(0.3).timeout
		print(Global.Score)
		
		Robot_mad(Global.Score)
		count=3
		#switch game
		switch_minigame()
		
	elif Global.Score==3 and count==3:
		await get_tree().create_timer(0.3).timeout
		print(Global.Score)
		Robot_mad(Global.Score)
		count=4
		#switch game
		switch_minigame()
		
	elif Global.Score==4 and count==4:
		await get_tree().create_timer(0.3).timeout
		print(Global.Score)
		
		Robot_mad(Global.Score)
		count=10
		#switch game
		switch_minigame()
		
	elif Global.Score==21:
		get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")
		count=21
	else:
		pass


func Robot_mad(score):
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	tween.parallel().tween_property($robot, "scale", Vector2(20, 20), 0.5)
	tween.parallel().tween_property($Player, "scale", Vector2(14, 14), 0.5)

	$CanvasLayer.visible = true

	$CanvasLayer.process_mode = Node.PROCESS_MODE_ALWAYS
	$CanvasLayer2.process_mode = Node.PROCESS_MODE_ALWAYS
	$dialogue_box.process_mode = Node.PROCESS_MODE_ALWAYS

	get_tree().paused = true

	if score == 2 and count==2:
		$dialogue_box.start_dialogue("Robot: Human is winning")
		count+=1
	elif score == 3 and count==3:
		$dialogue_box.start_dialogue("Robot: Human capacity is low, robot must win")
		count+=1
	elif score == 4 and count==4:
		$CanvasLayer2.visible = true
		$CanvasLayer.visible = false
		$dialogue_box.start_dialogue("Robot: Unexpected output from human...EXTERMINATE")
		count+=1

	await get_tree().create_timer(10).timeout
	$CanvasLayer.visible = false
	$CanvasLayer2.visible = false
	var tween2 = create_tween()
	tween2.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	tween2.parallel().tween_property($robot, "scale", Vector2(15, 15), 0.5)
	tween2.parallel().tween_property($Player, "scale", Vector2(19, 19), 0.5)
	
func Robot_break():
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	tween.parallel().tween_property($robot, "scale", Vector2(20, 20), 0.5)
	tween.parallel().tween_property($Player, "scale", Vector2(14, 14), 0.5)

	$CanvasLayer3.visible=true

	$CanvasLayer3.process_mode = Node.PROCESS_MODE_ALWAYS

	$dialogue_box.process_mode = Node.PROCESS_MODE_ALWAYS

	get_tree().paused = true
	$dialogue_box.start_dialogue("Robot: EXTERMINATE, EXTERMINATE, EXTERMINATE")
	print("robot break")
	
func switch_minigame():
	if curr_minigame == "match":
		match_off()
		goFish_activate()
		
	elif curr_minigame == "go fish":
		goFish_off()
		match_activate()
	
func match_off():
	#toggle all match visibility off
	pass
	
func goFish_off():
	#toggle all goFish visibility off
	pass
	
func match_activate():
	# toggle all match visibility on
	pass
	
func goFish_activate():
	# toggle all go Fish visibility on
	pass
	
#minigame logic
#toggle game visibility on and off so progress is "saved"

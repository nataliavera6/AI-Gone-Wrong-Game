extends Node2D

var count=2
# Called when the node enters the scene tree for the first time.

var curr_minigame = "match"

func _ready() -> void:
	$HBoxContainer/Memory.visible = true
	$HBoxContainer/GoFish.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$matches_man.text="Matches: %s" % Global.matchScore
	$matchesrobot.text="Matches: %s" % Global.robot_matchScore
	$matches_man2.text="Steals: %s" % (Global.tempScore-Global.matchScore)
	$matchesrobot2.text="Steals: %s" % (Global.robot_score-Global.robot_matchScore)
	if Global.Score>Global.robot_score:
		$winingstateman.text="winning"
		$winningstaterobot.text="losing"
	elif Global.Score<Global.robot_score:
		$winingstateman.text="losing"
		$winningstaterobot.text="winning"
	else:
		$winingstateman.text="tied"
		$winningstaterobot.text="tied"
	#if count==500:
		#Global.temoScore=10
		#count+=1
	#elif count==100:
		#Global.temoScore=5
	#elif count==200:
		#Global.temoScore=6
	#elif count==300:
		#Global.temoScore=7
	#elif count==500:
		#Global.tempScore=20
	#print(count)
	#if Global.tempScore == -1 and Global.robot_score <= Global.tempScore:
		#await get_tree().create_timer(0.3).timeout
		#count=2
		#Robot_break()
	#
		#print("-1 score")
		##switch game
	#
	if Global.robot_matchScore >= 11 or Global.Score==-1:
		get_tree().change_scene_to_file("res://Scenes/LoseScreen.tscn")
	elif (Global.matchScore >= 11 and curr_minigame=="match") or Global.Score==-1:
		Global.tempScore=-1
		count = 11
		await get_tree().create_timer(0.3).timeout
		count=2
		Robot_break()
	
		print("-1 score")
		#get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")
	elif Global.tempScore>0 and Global.Score!=Global.tempScore and Global.robot_score <= Global.tempScore:
		
		if count==3  :
			await get_tree().create_timer(0.3).timeout
			print(Global.tempScore)
			count = 4
			Robot_mad(3)
			
			print("3 score")
		
			# switch game
			#switch_minigame()
		elif count==2 :
			await get_tree().create_timer(0.3).timeout
			print(Global.tempScore)
			count = 3
			Robot_mad(2)
			
		
			print("2 score")
			# switch game
			#switch_minigame()
		elif count==4:
			await get_tree().create_timer(0.3).timeout
			print(Global.tempScore)
			count=5
			Robot_mad(4)
			
		
			print("4 score")
			# switch game
			#switch_minigame()
		

		






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
	if score!=5:
		switch_minigame()
		await get_tree().create_timer(0.05).timeout
		switch_minigame()
		await get_tree().create_timer(0.05).timeout
		switch_minigame()

	
	if score == 3 :
		$dialogue_box.start_dialogue("Robot: Human capacity is low, robot must win")
	
		Global.Score=Global.tempScore
	elif score == 2 :
		$matchesrobot2.visible=true
		$matches_man2.visible=true
		$dialogue_box.start_dialogue("Robot: Human is winning")
		
		Global.Score=Global.tempScore
	elif score ==4 :
		$CanvasLayer2.visible = true
		$CanvasLayer.visible = false
		$dialogue_box.start_dialogue("Robot: Unexpected output from human...EXTERMINATE")
	
	Global.Score=Global.tempScore
	

	await get_tree().create_timer(3).timeout
	$CanvasLayer.visible = false
	$CanvasLayer2.visible = false
	var tween2 = create_tween()
	tween2.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	tween2.parallel().tween_property($robot, "scale", Vector2(15, 15), 0.5)
	tween2.parallel().tween_property($Player, "scale", Vector2(19, 19), 0.5)
	if count==5:
		count=4
	
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
	await get_tree().create_timer(4).timeout
	get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")
	
func switch_minigame():
	#Global.temoScore=0
	#Global.robot_score=0
	#
	Global.switched=true
	if curr_minigame == "match":
		match_off()
		goFish_activate()
		curr_minigame = "go fish"
		
	elif curr_minigame == "go fish":
		goFish_off()
		match_activate()
		curr_minigame = "match"
	
func match_off():
	#toggle all match visibility off
	$HBoxContainer/Memory.visible = false
	
func goFish_off():
	#toggle all goFish visibility off
	$HBoxContainer/GoFish.visible = false
	
func match_activate():
	# toggle all match visibility on
	$HBoxContainer/Memory.visible = true
	
func goFish_activate():
	# toggle all go Fish visibility on
	$HBoxContainer/GoFish.visible = true
	
#minigame logic
#toggle game visibility on and off so progress is "saved"

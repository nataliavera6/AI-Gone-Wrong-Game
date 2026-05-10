extends Node2D

var Card = preload("res://Scenes/memory_card.tscn")

const ROW = 7
const COL = 6

var cards = []
var open_cards = []

var busy = false
var player_turn = true

var ai_nuke = true

var robot_memory = {}

var Textures = [
	preload("res://assets/Individual/With Border/2x/portrait-with-border1.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border5.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border6.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border7.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border8.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border19.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border20.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border21.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border23.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border24.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border25.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border27.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border28.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border30.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border40.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border41.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border45.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border46.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border47.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border48.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border49.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border50.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border51.png"),
	preload("res://assets/Individual/With Border/2x/portrait-with-border62.png"),
]


func _ready() -> void:

	for t in Textures:

		var c1 = Card.instantiate()
		c1.get_node("Front").texture = t

		var c2 = Card.instantiate()
		c2.get_node("Front").texture = t

		cards.append(c1)
		cards.append(c2)

	cards.shuffle()

	for row in range(ROW):
		for col in range(COL):

			var index = col + row * COL

			if index >= cards.size():
				return

			var c = cards[index]

			c.position = Vector2(32, 32) + Vector2(col * 50, row * 50)

			add_child(c)


func card_selected(card):

	if busy:
		return

	if !player_turn:
		return

	if card.is_open or card.matched:
		return

	if open_cards.size() >= 2:
		return

	open_card(card)

	if open_cards.size() == 2:

		busy = true

		await get_tree().create_timer(0.8).timeout

		check_match()


func open_card(card):

	card.get_node("AnimationPlayer").play("turn_forward")
	card.is_open = true

	open_cards.append(card)

	remember_card(card)


func remember_card(card): #this is to make the robot play better

	var tex = card.get_node("Front").texture

	if !robot_memory.has(tex):
		robot_memory[tex] = []

	if !robot_memory[tex].has(card)  and ai_nuke:
		robot_memory[tex].append(card)
		
	ai_nuke = !ai_nuke


func check_match():

	var card1 = open_cards[0]
	var card2 = open_cards[1]

	var tex1 = card1.get_node("Front").texture
	var tex2 = card2.get_node("Front").texture

	if tex1 == tex2:

		card1.matched = true
		card2.matched = true

		if player_turn:
			Global.Score += 1
		else:
			Global.robot_score += 1

		open_cards.clear()
		busy = false

		if !player_turn:
			await get_tree().create_timer(1.0).timeout
			robot_turn()

	else:

		$TurnBackFailedMatch.start()


func _on_turn_back_failed_match_timeout() -> void:

	for card in open_cards:

		card.get_node("AnimationPlayer").play("turn_backward")
		card.is_open = false

	open_cards.clear()

	busy = false

	player_turn = !player_turn

	if !player_turn:
		await get_tree().create_timer(1.0).timeout
		robot_turn()


func robot_turn():

	if busy:
		return

	if player_turn:
		return

	busy = true

	var chosen_cards = choose_robot_cards()

	if chosen_cards.size() < 2:
		busy = false
		return

	await get_tree().create_timer(0.8).timeout

	open_card(chosen_cards[0])

	await get_tree().create_timer(0.8).timeout

	open_card(chosen_cards[1])

	await get_tree().create_timer(0.8).timeout

	check_match()


func choose_robot_cards():

	var known_match = find_known_match()

	if known_match.size() == 2:
		return known_match

	var available_cards = get_available_cards()

	available_cards.shuffle()

	if available_cards.size() >= 2:
		return [available_cards[0], available_cards[1]]

	return []


func find_known_match():

	for tex in robot_memory.keys():

		var remembered_cards = []

		for card in robot_memory[tex]:

			if is_card_available(card):
				remembered_cards.append(card)

		if remembered_cards.size() >= 2:
			return [remembered_cards[0], remembered_cards[1]]

	return []


func get_available_cards():

	var available_cards = []

	for card in cards:

		if is_card_available(card):
			available_cards.append(card)

	return available_cards


func is_card_available(card):

	if card == null:
		return false

	if card.matched:
		return false

	if card.is_open:
		return false

	return true

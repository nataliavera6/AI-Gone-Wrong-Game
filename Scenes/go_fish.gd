extends Node2D


# Card scene
var Card = preload("res://Scenes/go_fish_card.tscn")

# Card data
var ranks = [
	"A", "2", "3", "4", "5",
	"6", "7", "8", "9", "10",
	"J", "Q", "K"
]

var suits = [
	"Hearts",
	"Diamonds",
	"Clubs",
	"Spades"
]

var deck = []

var player_hand = []
var robot_hand = []

var player_books = 0
var robot_books = 0

var player_turn = true
var game_over = false

var robot_score = 0


func _ready():

	create_deck()

	deal_cards()

	check_books(player_hand, true)
	check_books(robot_hand, false)

	display_all_cards()

	start_player_turn()


func create_deck():

	deck.clear()

	for suit in suits:

		for rank in ranks:

			var card_data = {
				"rank": rank,
				"suit": suit,
				"texture": get_card_texture(rank, suit)
			}

			deck.append(card_data)

	deck.shuffle()


func get_card_texture(rank, suit):

	var file_name = ""

	match rank:

		"A":
			file_name = "Ace"

		"J":
			file_name = "Jack"

		"Q":
			file_name = "Queen"

		"K":
			file_name = "King"

		_:
			file_name = rank

	var path = "res://assets/Pixel Art Card Deck/%s/%s.png" % [suit, file_name]

	return load(path)


func deal_cards():

	for i in range(7):

		player_hand.append(draw_card())
		robot_hand.append(draw_card())


func draw_card():

	if deck.is_empty():
		return null

	return deck.pop_back()


func display_all_cards():

	display_player_hand()
	display_robot_hand()
	display_deck()


func display_player_hand():

	for child in $PlayerHand.get_children():
		child.queue_free()

	for i in range(player_hand.size()):

		var card = Card.instantiate()

		card.position = Vector2(i * 50, 500)

		card.get_node("Front").texture = player_hand[i]["texture"]
		card.get_node("Front").z_index = 1

		$PlayerHand.add_child(card)


func display_robot_hand():

	for child in $RobotHand.get_children():
		child.queue_free()

	for i in range(robot_hand.size()):

		var card = Card.instantiate()

		card.position = Vector2(i * 50, 80)

		card.get_node("Back").z_index = 1

		$RobotHand.add_child(card)


func display_deck():

	for child in $Deck.get_children():
		child.queue_free()

	if deck.is_empty():
		return

	var card = Card.instantiate()

	var viewport_size = get_viewport_rect().size
	card.global_position = viewport_size / 2

	card.get_node("Front").visible = false

	$Deck.add_child(card)


func update_dropdown():

	$ChooseRank.clear()

	var added_ranks = []

	for card in player_hand:

		var rank = card["rank"]

		if !added_ranks.has(rank):

			added_ranks.append(rank)

			$ChooseRank.add_item(rank)


func start_player_turn():

	if game_over:
		return

	player_turn = true

	if player_hand.is_empty():

		if !deck.is_empty():
			player_hand.append(draw_card())

		else:
			check_game_over()
			return

	display_all_cards()

	update_dropdown()

	$Label.text = "Choose a rank to ask for"

	$Ask.disabled = false


func _on_ask_pressed() -> void:

	if !player_turn:
		return

	if $ChooseRank.item_count == 0:
		return

	$Ask.disabled = true

	var selected_index = $ChooseRank.selected

	var selected_rank = $ChooseRank.get_item_text(selected_index)

	$Label2.text = "You: Do you have " + selected_rank + "?"

	await get_tree().create_timer(3).timeout

	player_ask(selected_rank)


func player_ask(rank):

	if hand_has_rank(robot_hand, rank):

		$Label.text = "Robot has the card!"

		var cards_to_transfer = []

		for card in robot_hand:

			if card["rank"] == rank:
				cards_to_transfer.append(card)

		for card in cards_to_transfer:

			robot_hand.erase(card)
			player_hand.append(card)

		check_books(player_hand, true)

		display_all_cards()

		check_game_over()

		await get_tree().create_timer(1.0).timeout

		start_player_turn()

	else:

		$Label.text = "GO FISH!"

		await get_tree().create_timer(1.0).timeout

		go_fish(player_hand, true)


func robot_turn():

	if game_over:
		return

	player_turn = false

	$Ask.disabled = true

	if robot_hand.is_empty():

		if !deck.is_empty():
			robot_hand.append(draw_card())

		else:
			check_game_over()
			return

	display_all_cards()

	var chosen_card = robot_hand.pick_random()

	var chosen_rank = chosen_card["rank"]

	$Label2.text = "Robot asks for: " + chosen_rank

	await get_tree().create_timer(1.0).timeout

	if hand_has_rank(player_hand, chosen_rank):

		$Label2.text = "You had the card!"

		var cards_to_transfer = []

		for card in player_hand:

			if card["rank"] == chosen_rank:
				cards_to_transfer.append(card)

		for card in cards_to_transfer:

			player_hand.erase(card)
			robot_hand.append(card)

		check_books(robot_hand, false)

		display_all_cards()

		check_game_over()

		await get_tree().create_timer(1.0).timeout

		robot_turn()

	else:

		$Label2.text = "Robot goes fishing!"

		await get_tree().create_timer(1.0).timeout

		go_fish(robot_hand, false)


func go_fish(hand, is_player):

	if deck.is_empty():

		check_game_over()
		return

	var drawn_card = draw_card()

	hand.append(drawn_card)

	check_books(hand, is_player)

	display_all_cards()

	check_game_over()

	await get_tree().create_timer(1.0).timeout

	if is_player:
		robot_turn()
	else:
		start_player_turn()


func hand_has_rank(hand, rank):

	for card in hand:

		if card["rank"] == rank:
			return true

	return false


func check_books(hand, is_player):

	var counts = {}

	for card in hand:

		var rank = card["rank"]

		if !counts.has(rank):
			counts[rank] = 0

		counts[rank] += 1

	for rank in counts.keys():

		if counts[rank] >= 4:
			if is_player: #creao que el score update va aquí
				Global.Score += 1

			var cards_to_remove = []

			for card in hand:

				if card["rank"] == rank:
					cards_to_remove.append(card)

			for card in cards_to_remove:
				hand.erase(card)

			if is_player:

				player_books += 1

				Global.Score += 1

				$Label2.text = "You completed a book of " + rank + "s!"

			else:

				robot_books += 1
				
				Global.robot_score += 1

				$Label2.text = "Robot completed a book of " + rank + "s!"


func check_game_over():

	if deck.is_empty():

		game_over = true

		if player_books > robot_books:

			Global.Score += 2

			$Label.text = "PLAYER WINS!"

		elif robot_books > player_books:
			
			Global.robot_score += 2

			$Label.text = "ROBOT WINS!"

		else:

			$Label.text = "DRAW!"

		await get_tree().create_timer(2.0).timeout

		get_tree().change_scene_to_file("res://Scenes/EndScreen.tscn")

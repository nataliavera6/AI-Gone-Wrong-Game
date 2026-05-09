extends Node2D

var Card = preload("res://Scenes/memory_card.tscn")

const ROW = 7
const COL = 6

var cards = []
var open_cards = []

var busy = false


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

	# Create pairs
	for t in Textures:

		var c1 = Card.instantiate()
		c1.get_node("Front").texture = t

		var c2 = Card.instantiate()
		c2.get_node("Front").texture = t

		cards.append(c1)
		cards.append(c2)

	# Shuffle cards
	cards.shuffle()

	# Place cards
	for row in range(ROW):
		for col in range(COL):

			var index = col + row * COL

			if index >= cards.size():
				return

			var c = cards[index]

			c.position = Vector2(32, 32) + Vector2(col * 50, row * 50)

			add_child(c)


func card_selected(card):

	# Prevent clicks while resolving
	if busy:
		return

	# Prevent selecting more than 2 cards
	if open_cards.size() >= 2:
		return

	card.get_node("AnimationPlayer").play("turn_forward2")
	
	card.is_open = true

	open_cards.append(card)

	# Wait until exactly 2 cards selected
	if open_cards.size() == 2:

		busy = true

		check_match()


func check_match():

	var card1 = open_cards[0]
	var card2 = open_cards[1]

	var tex1 = card1.get_node("Front").texture
	var tex2 = card2.get_node("Front").texture


	# MATCH
	if tex1 == tex2:

		card1.matched = true
		card2.matched = true
		#corresponding player gets awarded point
		#same player plays next turn

		open_cards.clear()

		busy = false


	# NO MATCH
	else:

		$TurnBackFailedMatch.start()


func _on_turn_back_failed_match_timeout() -> void:

	for card in open_cards:

		card.get_node("AnimationPlayer").play("turn_backward2")

		card.is_open = false

	open_cards.clear()

	busy = false
	
	#switvh turn to other player

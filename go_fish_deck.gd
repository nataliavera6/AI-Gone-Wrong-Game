extends Node

var card = preload("res://Scenes/go_fish_card.tscn")
var cards = []

var ranks = ["A", "2", "3", "4", "5",
			 "6", "7", "8", "9", "10",
			 "J", "Q", "K"]

var suits = ["Hearts", "Diamonds",
			 "Clubs", "Spades"]
			
#Go fish rules: 52 cards with all jokers removed. Each player is dealth 7 cards.

func _ready():
	create_deck()
	cards.shuffle()

func create_deck():
	for suit in suits:
		for rank in ranks:
			cards.append(card.new(rank, suit))

func draw_card():
	if cards.size() > 0:
		return cards.pop_back()
	return null

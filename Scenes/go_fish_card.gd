# card.gd
extends Node2D
class_name go_Fish_Card

var rank : String
var suit : String

func _init(r, s):
	rank = r
	suit = s

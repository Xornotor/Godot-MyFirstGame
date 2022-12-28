extends Node

var checkpoint_pos = 0

func _ready():
	Global.fruits = 0
	$Transition_in.zero_fx()
	$Transition_out.change_scene("")

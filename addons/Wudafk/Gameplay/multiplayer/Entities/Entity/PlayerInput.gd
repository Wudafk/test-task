class_name PlayerInput extends Node

var input_dir : Vector2 = Vector2.ZERO
var jump_input := false
var attack_input := false
var run_input := false
#var dash_input := false

func clear_input():
	self.input_dir = Vector2()
	self.jump_input = false
	self.attack_input = false
	self.run_input = false
	

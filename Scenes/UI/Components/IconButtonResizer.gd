extends Control

func _process(_delta):
	var width = $InfoLabel.get_minimum_size().x
	custom_minimum_size.x = max(width, 200) + 20

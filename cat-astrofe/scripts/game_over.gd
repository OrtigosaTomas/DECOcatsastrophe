extends Control


func _on_timer_finished():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _ready():
	controlcajas.destruccion = true
	var timer = Timer.new()
	timer.wait_time = 10
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(_on_timer_finished)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

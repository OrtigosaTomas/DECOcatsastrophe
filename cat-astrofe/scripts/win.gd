extends Control

@onready var label: Label = $timer_label
var time_left

func _on_timer_finished():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _ready():
	
	var timer = Timer.new()
	timer.wait_time = 10
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(_on_timer_finished)
	@warning_ignore("integer_division")
	time_left = controlcajas.tiempoTranscurrido
	var minutes = time_left / 60
	var seconds = time_left % 60
	label.text = "%2d:%02d" % [minutes, seconds]
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

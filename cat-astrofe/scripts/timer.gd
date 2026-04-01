extends Node2D

@onready var timer_label: Label = $timer_label
@onready var musica: AudioStreamPlayer2D = $musica

var time_left = 120
var timer: Timer

func _ready():
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_Timer_timeout)
	timer.start()
	update_timer_label()

func _on_Timer_timeout():
	controlcajas.tiempoTranscurrido += 1
	time_left -= 1
	update_timer_label()
	if time_left <= 0:
		timer.stop()
		get_tree().change_scene_to_file("res://scenes/gameOver.tscn")

func update_timer_label():
	@warning_ignore("integer_division")
	var minutes = time_left / 60
	var seconds = time_left % 60
	timer_label.text = "%2d:%02d" % [minutes, seconds]

func _on_musica_finished() -> void:
	musica.play()

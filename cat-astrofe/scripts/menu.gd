extends Control

@onready var audio_stream: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	$VBoxContainer/ButtonPlay.connect("pressed", Callable(self, "_on_play_pressed"))
	$VBoxContainer/ButtonOptions.connect("pressed", Callable(self, "_on_options_pressed"))
	$VBoxContainer/ButtonExit.connect("pressed", Callable(self, "_on_exit_pressed"))

func _on_play_pressed():
	print("Jugar seleccionado")
	get_tree().change_scene_to_file("res://scenes/comic.tscn")

func _on_options_pressed():
	print("Opciones seleccionado")
	get_tree().change_scene_to_file("res://scenes/settings.tscn")

func _on_exit_pressed():
	print("Salir seleccionado")
	get_tree().quit()
	
func _on_audio_stream_player_2d_finished() -> void:
	audio_stream.play()

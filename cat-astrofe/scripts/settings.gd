extends Control

@onready var slider_volume = $HSlider
@onready var btn_windowed = $ButtonWindowed
@onready var btn_fullscreen = $ButtonFullscreen

func _ready():
	btn_windowed.text = "Windowed"
	btn_fullscreen.text = "Fullscreen"
	
	btn_windowed.connect("pressed", Callable(self, "_on_windowed_pressed"))
	btn_fullscreen.connect("pressed", Callable(self, "_on_fullscreen_pressed"))

	slider_volume.connect("value_changed", Callable(self, "_on_volume_changed"))

func _on_windowed_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_fullscreen_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

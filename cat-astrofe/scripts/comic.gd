extends Control

@onready var audio_stream: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var skip: Button = $Button
@onready var sprite_2d_4: Sprite2D = $Sprite2D4
@onready var sprite_2d_3: Sprite2D = $Sprite2D3
@onready var sprite_2d_2: Sprite2D = $Sprite2D2
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var controles: Sprite2D = $controles

func _on_timer_finished():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _ready():
	
	if OS.get_name() == "Android":
		controles.visible = false
	
	var timer = Timer.new()
	timer.wait_time = 25.0
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(_on_timer_finished)
	
	$Button.connect("pressed", Callable(self, "_on_skip_pressed"))
	
	sprite_2d.modulate.a = 1
	sprite_2d_2.modulate.a = 0.0
	sprite_2d_3.modulate.a = 0.0
	sprite_2d_4.modulate.a = 0.0

	fade_in_sequence()

func fade_in_sequence():
	var tween = create_tween()
	
	tween.tween_property(sprite_2d_2, "modulate:a", 1.0, 1.0).set_delay(5.0)
	
	tween.tween_property(sprite_2d_3, "modulate:a", 1.0, 1.0).set_delay(5.0)
	
	tween.tween_property(sprite_2d_4, "modulate:a", 1.0, 1.0).set_delay(5.0)

func _on_skip_pressed():
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_audio_stream_player_2d_finished() -> void:
	audio_stream.play()

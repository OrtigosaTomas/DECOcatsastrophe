extends Area2D

var player_in_range = false
var cajaTipo = "Floor"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sonidoCaja: AudioStreamPlayer2D = $sonidoCaja
var decoFloor = preload("res://scenes/decoFloor.tscn")
var effect_scene = preload("res://scenes/fx.tscn")
var cajaActiva = 1

func spawn_deco(categoria):

	if categoria == "floor":
		var deco_instance = decoFloor.instantiate()
		var anim = deco_instance.get_node("texturaDeco")
		anim.visible = true
		deco_instance.position = self.position
		deco_instance.name = "decoFloor" + str(controlcajas.decoFc)
		controlcajas.incFc()
		cajaActiva = 0
		anim.animation = "default_" + str(randi_range(1,21)) ; anim.play()
		get_parent().add_child(deco_instance)
		controlcajas.spawn_scene()
		self.queue_free()

func spawn_effect(posFx: Vector2):
	var fx_instance = effect_scene.instantiate()
	add_child(fx_instance)
	fx_instance.global_position = posFx
	return fx_instance

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = false

func _process(_delta: float) -> void:
	if controlcajas.destruccion == true:
		self.queue_free()
	if player_in_range and Input.is_action_just_pressed("interact"):
		interact()

func interact():
	animated_sprite.play("apertura")
	var fx = spawn_effect(self.position)
	fx.efecto("poof")
	sonidoCaja.play()
	await get_tree().create_timer(0.8).timeout
	animated_sprite.play("abierta")

	if cajaTipo == "Floor":
		spawn_deco("floor")

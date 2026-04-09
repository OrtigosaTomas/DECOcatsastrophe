extends Node2D

const velocidad = 500
const fuerza_salto = -600
const gravedad = 1200
const distancia_ataque = 200

var direccion = 1
var velocidad_y = 0.0
var objetivo = Vector2(0,0)

@onready var miau: AudioStreamPlayer2D = $miau
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var rayo_derecha: RayCast2D = $RayoDerecha
@onready var rayo_izquierda: RayCast2D = $RayoIzquierda
@onready var area_2d: Area2D = $Detector

var effect_scene = preload("res://scenes/fx.tscn")
var animaciones = ["idle", "jump", "jumpReady", "sleep", "walk", "curious"]
var posibles_targets := []
var target: RigidBody2D = null

var estado = "idle"
var tiempo_accion = 0.0
var duracion_accion = 0.0
var tiempo = 5
var intervalo = 3
var stop = false

func _process(delta: float) -> void:
	if not stop:
		tiempo -= delta
		if tiempo <= 0:
			_cambiar_animacion_aleatoria()

		var anim = animated_sprite.animation

		match anim:
			"sleep", "idle":
				velocidad_y = 0
			"curious":
				_buscar_objetivo(delta)
			"walk":
				if rayo_derecha.is_colliding():
					direccion = -1
					animated_sprite.flip_h = false
				if rayo_izquierda.is_colliding():
					direccion = 1
					animated_sprite.flip_h = true
				position.x += direccion * velocidad * delta
				velocidad_y = 0
			"jumpReady":
				velocidad_y = 0
			"jump", "attackFall":
				if is_on_floor():
					velocidad_y = fuerza_salto
				velocidad_y += gravedad * delta
				position.y += velocidad_y * delta
				if rayo_derecha.is_colliding():
					direccion = -1
					animated_sprite.flip_h = false
				if rayo_izquierda.is_colliding():
					direccion = 1
					animated_sprite.flip_h = true
				position.x += direccion * velocidad * delta
			_:
				velocidad_y = 0

func spawn_effect(posFx: Vector2):
	var fx_instance = effect_scene.instantiate()
	add_child(fx_instance)
	fx_instance.global_position = posFx
	return fx_instance

func _cambiar_animacion_aleatoria():
	# Generar un número aleatorio entre 0 y 2
	var chance = randi() % 3
	if chance == 0:
		# Una de cada tres veces reproducir "curious"
		animated_sprite.animation = "curious"
	else:
		# Las otras dos veces reproducir animación aleatoria
		var anim = animaciones[randi() % animaciones.size()]
		animated_sprite.animation = anim
	animated_sprite.play()
	intervalo = randf_range(2.0, 4.0)
	tiempo = intervalo

func is_on_floor():
	var rayo_suelo = $RayoSuelo
	return rayo_suelo.is_colliding()

func _ready():
	controlcajas.destruccion = false
	$Detector.connect("body_entered", Callable(self, "_on_body_entered"))
	$Detector.connect("body_exited", Callable(self, "_on_body_exited"))
	_cambiar_animacion_aleatoria()
	sonidos("miau")

func _on_body_entered(body):
	if body is RigidBody2D and body.collision_layer == 8 and body.colocado == true and body.agarrado == false:
		if body not in posibles_targets:
			posibles_targets.append(body)
			print("Detectado: " + body.name)
			sonidos("miau")

func _on_body_exited(body):
	if body.collision_layer != 8:
		posibles_targets.erase(body)

func obtener_target_mas_cercano() -> Node:
	var min_dist = INF
	var target_local = null
	for obj in posibles_targets:
		print("posibles objetivos: ",obj)
		var dist = position.distance_to(obj.position)
		if dist < min_dist:
			min_dist = dist
			target_local = obj
	return target_local

func _buscar_objetivo(delta):
	var nuevo_target = obtener_target_mas_cercano()
	if nuevo_target != null and nuevo_target.colocado ==true:
		print("miau(objetivo detectado)")
		target = nuevo_target
		var dist = position.distance_to(target.position)
		if dist <= distancia_ataque:
			stop = true
			animated_sprite.play("attackReady")
			sonidos("mggga")
			var fx = spawn_effect(self.position)
			fx.scale = Vector2(0.3, 0.3)
			if direccion == 1:
				fx.flip_h = true
				fx.position.x = fx.position.x + 50
			else:
				fx.flip_h = false
				fx.position.x = fx.position.x - 50
			fx.efecto("shine")
			await get_tree().create_timer(2.0).timeout
			animated_sprite.play("attack")
			fx = spawn_effect(self.position)
			fx.scale = Vector2(0.3, 0.3)
			if direccion == 1:
				fx.flip_h = true
				fx.position.x = fx.position.x + 50
			else:
				fx.flip_h = false
				fx.position.x = fx.position.x - 50
			fx.efecto("slice")
			sonidos("scratch")
			target.collision_mask = 4
			target.collision_layer = 4
			target.freeze = false
			target.agarrado = false
			target.colocado = false
			controlcajas.decWin()
			controlcajas.removePlacedDeco(target.name)
			target.z_index = 20
			await get_tree().create_timer(2.0).timeout
			animated_sprite.play("attackFall")
			position.y += -1 * velocidad * delta
			stop = false
		else:
			objetivo = (target.position - position).normalized()
			print(objetivo)
			position += objetivo * velocidad * delta

func sonidos(sonido):
	if sonido == "miau":
		var miauu = load("res://assets/sounds/fx/miau.wav")
		miau.stream = miauu
		miau.play()
	elif sonido == "mggga":
		var mggga = load("res://assets/sounds/fx/mggga.wav")
		miau.stream = mggga
		miau.play()
	elif sonido == "scratch":
		var scratch = load("res://assets/sounds/fx/1-scratch_.wav")
		miau.stream = scratch
		miau.play()

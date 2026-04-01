extends Area2D

var bodies_in_area := []
var areaOcupada = false
@onready var player: CharacterBody2D = %player
var bodyColocado = null
var colocadoFound = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node) -> void:
	if body.name.begins_with("decoFloor") and body.colocado == false:
		bodies_in_area.append(body)

func _on_body_exited(body: Node) -> void:
	if body.name.begins_with("decoFloor"):
		bodies_in_area.erase(body)

func _process(_delta: float) -> void:
	if not areaOcupada:
		if Input.is_action_just_pressed("interact"):
			for body in bodies_in_area:
				if body.name.begins_with("decoFloor") and body.colocado == false and body.agarrado == true:
					print("placed on AreaFloor: ", body.name)
					player._on_place_object(body, self.global_position)
					areaOcupada = true
					body.colocado = true
					body.agarrado = false
					bodyColocado = body.name
					break
		return

	if areaOcupada and bodyColocado != null:
		var placed_bodies = controlcajas.getPlacedDeco()
		if bodyColocado in placed_bodies:
			# El objeto sigue colocado, no hacer nada
			pass
		else:
			# El objeto ya no está colocado, limpiar estado
			areaOcupada = false
			for body in bodies_in_area.duplicate():
				if body.name == bodyColocado:
					body.colocado = false
					bodies_in_area.erase(body)
					break
			bodyColocado = null

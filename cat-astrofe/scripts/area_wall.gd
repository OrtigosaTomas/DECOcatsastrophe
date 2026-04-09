extends Area2D

var bodies_in_area := []
var areaOcupada = false
@onready var player: CharacterBody2D = %player
@onready var debug_b: Sprite2D = $debugB
var bodyColocado = null
var colocadoFound = false
var placeFound = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node) -> void:
	if body.name.begins_with("decoWall") and body.agarrado == true:
		placeFound = true
	if body.name.begins_with("decoWall") and body.colocado == false:
		bodies_in_area.append(body)

func _on_body_exited(body: Node) -> void:
	if body.name.begins_with("decoWall") and body.agarrado == true:
		placeFound = false
	if body.name.begins_with("decoWall"):
		bodies_in_area.erase(body)

func _process(_delta: float) -> void:
	
	if controlcajas.wallAgarrado == true and areaOcupada == false:
		debug_b.visible = true
	else:
		debug_b.visible = false
	
	if placeFound == true:
		debug_b.modulate = Color(0.0, 15.514, 0.0, 1.0)
	else:
		debug_b.modulate = Color("e50026ff")
		
	if not areaOcupada:
		if Input.is_action_just_pressed("interact"):
			for body in bodies_in_area:
				if body.name.begins_with("decoWall") and body.colocado == false and body.agarrado == true:
					print("placed on AreaWall: ", body.name)
					player._on_place_object(body, self.global_position)
					areaOcupada = true
					body.colocado = true
					body.agarrado = false
					bodyColocado = body.name
					break
		return

	if areaOcupada != null:
		var placed_bodies = controlcajas.getPlacedDeco()
		if bodyColocado in placed_bodies:
			pass
		else:
			areaOcupada = false
			for body in bodies_in_area.duplicate():
				if body.name == bodyColocado:
					body.colocado = false
					bodies_in_area.erase(body)
					break
			bodyColocado = null

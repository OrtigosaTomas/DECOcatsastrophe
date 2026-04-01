extends Node

var deco = []
var max_spawns_per_category = [7, 3, 2]
var current_spawns_per_category = [0, 0, 0]
var total_max_spawns = 12
var total_spawns = 0
var decoFc = 1
var decoWc = 1
var decoSc = 1
var winCon = 0
var destruccion = false
var tiempoTranscurrido = 0

func setPlacedDeco(nombreDeco):
	deco.append(nombreDeco)

func removePlacedDeco(nombreDeco):
	deco.erase(nombreDeco)

func getPlacedDeco():
	return deco

func _ready() -> void:
	destruccion = false

func incWin():
	winCon = winCon + 1
	print("puntos: ",winCon)
	if winCon > 13 or winCon == 13:
		destruccion = true
		reset_data()
		get_tree().change_scene_to_file("res://scenes/win.tscn")

func decWin():
	winCon = winCon - 1
	print("puntos: ",winCon)

func incFc():
	decoFc = decoFc + 1

func incWc():
	decoWc = decoWc + 1

func incSc():
	decoSc = decoSc + 1
	
var scenes = [
	preload("res://scenes/cajaStand.tscn"),  # Categoría 1
	preload("res://scenes/cajaFloor.tscn"),  # Categoría 2
	preload("res://scenes/cajaWall.tscn")   # Categoría 3
]

func reset_data():
	max_spawns_per_category = [7, 3, 2]
	current_spawns_per_category = [0, 0, 0]
	total_max_spawns = 12
	total_spawns = 0
	decoFc = 1
	decoWc = 1
	decoSc = 1
	winCon = 0

func spawn_scene():
	if total_spawns >= total_max_spawns:
		print("Se alcanzó el límite total de spawns")
		return

	var available_categories = []
	for i in range(scenes.size()):
		if current_spawns_per_category[i] < max_spawns_per_category[i]:
			available_categories.append(i)
	
	var chosen_category = available_categories[randi() % available_categories.size()]
	
	var instance = scenes[chosen_category].instantiate()
	get_parent().add_child(instance)

	if instance.has_method("set_position"):
		instance.set_position(Vector2(900,600))
	else:
		if instance.has_variable("position"):
			instance.position = Vector2(900,600)

	current_spawns_per_category[chosen_category] += 1
	total_spawns += 1
	
	print("Spawn número %d de categoría %d" % [total_spawns, chosen_category + 1])

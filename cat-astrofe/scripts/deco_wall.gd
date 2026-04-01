extends RigidBody2D

@onready var debug_a: Sprite2D = $debugA
@onready var debug_c: Sprite2D = $debugC

var colocado = false
var agarrado = false

func _process(_delta):
	if controlcajas.destruccion == true:
		self.queue_free()
	
	if colocado == true:
		debug_c.visible = false
	else:
		debug_c.visible = false

	if agarrado == true:
		debug_a.visible = false
	else:
		debug_a.visible = false

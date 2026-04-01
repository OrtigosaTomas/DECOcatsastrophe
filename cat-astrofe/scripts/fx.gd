extends AnimatedSprite2D

func efecto(tipo):
	if tipo == "poof":
		self.play("poof")
	elif tipo == "slice":
		self.play("slice")
	elif tipo == "shine":
		self.play("shine")
	self.visible = true

func _ready():
	await get_tree().create_timer(0.5).timeout
	queue_free()

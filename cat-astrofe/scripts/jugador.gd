extends CharacterBody2D

const SPEED = 500.0

@onready var pasos: AudioStreamPlayer2D = %pasos
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var caja: Node2D = $".."

var grabbed_object = null
var grab_area = null
var pin_joint: PinJoint2D = null
var tiempo_pasos = 0.0
var intervalo_pasos = 0.4

func _physics_process(delta: float) -> void:

	var direction_x := Input.get_axis("izq", "der")
	var direction_y := Input.get_axis("arriba", "abajo")

	if direction_x > 0:
		animated_sprite.flip_h = false
	elif direction_x < 0:
		animated_sprite.flip_h = true

	if direction_x == 0 and direction_y == 0:
		animated_sprite.play("quieto")
	else:
		animated_sprite.play("corro")
		tiempo_pasos += delta
		if tiempo_pasos >= intervalo_pasos:
			pasos.play()
			tiempo_pasos = 0

	if direction_x != 0:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction_y != 0:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func _ready():
	grab_area = $grab_area

func _process(_delta):
	if Input.is_action_just_pressed("grab"):
		var bodies = grab_area.get_overlapping_bodies()
		for body in bodies:
			if grabbed_object == null:
				if body is RigidBody2D and body.freeze == false and body.colocado == false and body.agarrado == false:
					grabbed_object = body
					body.collision_mask = 0
					body.collision_layer = 6
					pin_joint = PinJoint2D.new()
					pin_joint.node_a = self.get_path()
					pin_joint.node_b = body.get_path()
					pin_joint.position = body.global_position
					get_parent().add_child(pin_joint)
					body.agarrado = true
					if body.name.begins_with("decoFloor"):
						controlcajas.floorAgarrado = true
					if body.name.begins_with("decoWall"):
						controlcajas.wallAgarrado = true
					if body.name.begins_with("decoStand"):
						controlcajas.standAgarrado = true
					break
			else:
				if pin_joint:
					pin_joint.queue_free()
					pin_joint = null
				grabbed_object.collision_mask = 4
				grabbed_object.collision_layer = 4
				grabbed_object.agarrado = false
				controlcajas.wallAgarrado = false
				controlcajas.floorAgarrado = false
				controlcajas.standAgarrado = false
				grabbed_object = null

	if grabbed_object != null and not grabbed_object.colocado:
		if grabbed_object.name.begins_with("decoFloor"):
			grabbed_object.global_position = global_position + Vector2(50, -850)
		else:
			grabbed_object.global_position = global_position + Vector2(50, -700)

func _on_place_object(body, pos):
	if pin_joint:
		pin_joint.queue_free()
		pin_joint = null
	grabbed_object = body
	grabbed_object.colocado = true
	grabbed_object.global_position = pos
	grabbed_object.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	grabbed_object.collision_mask = 0
	grabbed_object.collision_layer = 8
	grabbed_object.set_deferred("global_position", pos)
	grabbed_object.freeze = true
	grabbed_object.rotation = 0.0
	grabbed_object.linear_velocity = Vector2.ZERO
	grabbed_object.angular_velocity = 0
	grabbed_object.z_index = 3
	grabbed_object.agarrado = false
	controlcajas.wallAgarrado = false
	controlcajas.floorAgarrado = false
	controlcajas.standAgarrado = false
	controlcajas.incWin()
	controlcajas.setPlacedDeco(grabbed_object.name)
	print("Objeto colocado ", body.name)
	grabbed_object = null

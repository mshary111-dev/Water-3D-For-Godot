extends Node

var water: Node = null

@export var float_force: float = 3.5
@export var water_drag: float = 1.2
@export var water_angular_drag: float = 0.8
@export var max_force: float = 120.0
@export var character_float_strength: float = 12.0

func _ready() -> void:
	call_deferred("_find_water")

func _find_water() -> void:
	water = get_tree().get_first_node_in_group("water")
	if not water:
		push_warning("BuoyancyManager: ما لقيت نود في مجموعة 'water'")

func _physics_process(delta: float) -> void:
	if not water or not water.has_method("get_height"):
		return

	for body in get_tree().get_nodes_in_group("buoyancy"):
		if body is RigidBody3D:
			_apply_rigidbody(body)
		elif body is CharacterBody3D:
			_apply_character(body, delta)
		elif body is Node3D:
			_apply_generic(body, delta)

func _apply_rigidbody(body: RigidBody3D) -> void:
	var probes = _get_probes(body)
	var submerged := false

	for probe in probes:
		var depth = water.get_height(probe.global_position) - probe.global_position.y
		if depth > 0.0:
			submerged = true
			var force_amount = clampf(float_force * depth * body.mass, 0.0, max_force)
			body.apply_force(Vector3.UP * force_amount, probe.global_position - body.global_position)

	if submerged:
		body.linear_damp = water_drag
		body.angular_damp = water_angular_drag
	else:
		body.linear_damp = 0.0
		body.angular_damp = 0.0

func _apply_character(body: CharacterBody3D, delta: float) -> void:
	var probes = _get_probes(body)
	var total_force = 0.0
	var submerged := false

	for probe in probes:
		var depth = water.get_height(probe.global_position) - probe.global_position.y
		if depth > 0.0:
			submerged = true
			total_force += depth

	if submerged:
		body.velocity.y += total_force * character_float_strength * delta
		body.velocity.x = lerp(body.velocity.x, 0.0, water_drag * delta)
		body.velocity.z = lerp(body.velocity.z, 0.0, water_drag * delta)

func _apply_generic(body: Node3D, delta: float) -> void:
	var probes = _get_probes(body)
	var average_depth = 0.0
	var count = 0

	for probe in probes:
		var depth = water.get_height(probe.global_position) - probe.global_position.y
		if depth > 0.0:
			average_depth += depth
			count += 1

	if count > 0:
		average_depth /= count
		body.global_position.y += average_depth * float_force * delta * 2.0

func _get_probes(body: Node) -> Array[Node3D]:
	var probes: Array[Node3D] = []
	for child in body.get_children():
		if child is Marker3D:
			probes.append(child)
	
	if probes.is_empty():
		probes.append(body)
	return probes

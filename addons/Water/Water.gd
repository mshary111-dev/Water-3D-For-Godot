extends MeshInstance3D

@export var amplitude_1: float = 0.4
@export var frequency_1: float = 0.15
@export var speed_1: float = 1.2
@export var direction_1: Vector2 = Vector2(1.0, 0.3).normalized()

@export var amplitude_2: float = 0.25
@export var frequency_2: float = 0.25
@export var speed_2: float = 0.9
@export var direction_2: Vector2 = Vector2(-0.6, 1.0).normalized()

@export var amplitude_3: float = 0.15
@export var frequency_3: float = 0.4
@export var speed_3: float = 1.5
@export var direction_3: Vector2 = Vector2(0.4, -0.8).normalized()

@export var overall_scale: float = 1.0

var time := 0.0

func _ready() -> void:
	add_to_group("water")

func _process(delta: float) -> void:
	time += delta

func get_height(world_pos: Vector3) -> float:
	var pos = Vector2(world_pos.x, world_pos.z)
	var t = time * 0.05          # ← هنا التعديل حسب طلبك

	var height = 0.0
	height += amplitude_1 * sin(pos.dot(direction_1) * frequency_1 + t * speed_1)
	height += amplitude_2 * sin(pos.dot(direction_2) * frequency_2 + t * speed_2)
	height += amplitude_3 * sin(pos.dot(direction_3) * frequency_3 + t * speed_3)

	return global_position.y + height * overall_scale

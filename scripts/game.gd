extends Node2D


var position_queue = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _get_crowd_positions (n : int, radius : float, base_pos : Vector2) -> Array[Vector2]:
	var positions : Array[Vector2] = []
	positions.append(Vector2.ZERO)
	var remaining : int = n
	var ring : int = 1

	while remaining > 0:
		var ring_radius : float = ring * radius * 2.0
		var circ : float = 2.0 * PI * ring_radius
		var capacity : int = int(circ / (radius * 2.0))
		var count : int = min(remaining, capacity)

		for i in count:
			var angle : float = (2.0 * PI * i) / count - PI / 2.0
			var pos : Vector2 = Vector2(cos(angle) * ring_radius, sin(angle) * ring_radius) + base_pos
			positions.append(pos)

		remaining -= count
		ring += 1

	return positions


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			position_queue = _get_crowd_positions(get_tree().get_node_count_in_group("lil_guys"), 10, event.position)
			get_tree().call_group("lil_guys", "get_movement_target_from_game")

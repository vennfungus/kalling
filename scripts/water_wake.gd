extends Node2D

var fish: AnimatedSprite2D
var phase := 0.0

func _ready() -> void:
	fish = get_parent() as AnimatedSprite2D
	phase = randf_range(0.0, TAU)

func _process(delta: float) -> void:
	phase = fmod(phase + delta * 2.4, TAU)
	queue_redraw()

func _draw() -> void:
	if fish == null:
		return

	var behind: Vector2
	var side: Vector2
	match fish.animation:
		"right":
			behind = Vector2.LEFT
			side = Vector2.UP
		"left":
			behind = Vector2.RIGHT
			side = Vector2.DOWN
		"up":
			behind = Vector2.DOWN
			side = Vector2.RIGHT
		"down":
			behind = Vector2.UP
			side = Vector2.LEFT
		_:
			return

	var wake_color := Color(0.65, 0.92, 1.0, 0.32)
	for strand in range(4):
		var points := PackedVector2Array()
		for step in range(9):
			var progress := float(step) / 8.0
			var ripple := sin(progress * TAU + phase + strand * PI) * 2.0 * progress
			var point := (
				behind * (20.0 + progress * 18.0)
				+ side * ((strand - 1.5) * 3.0 + ripple)
			)
			points.append(point)
		draw_polyline(points, wake_color, 1.0)

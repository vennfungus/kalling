extends AnimatedSprite2D

var swim_speed: float = 100.0
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	self_modulate = Color(0.88, 0.96, 1.0)
	pick_new_target()

func pick_new_target() -> void:
	var direction := randi() % 4
	var target_pos: Vector2

	match direction:
		0:
			target_pos = Vector2(position.x, randf_range(100.0, screen_size.y - 100.0))
			if target_pos.y >= position.y:
				target_pos.y = randf_range(100.0, position.y)
			play("up")
		1:
			target_pos = Vector2(position.x, randf_range(100.0, screen_size.y - 100.0))
			if target_pos.y <= position.y:
				target_pos.y = randf_range(position.y, screen_size.y - 100.0)
			play("down")
		2:
			target_pos = Vector2(randf_range(100.0, screen_size.x - 100.0), position.y)
			if target_pos.x >= position.x:
				target_pos.x = randf_range(100.0, position.x)
			play("left")
		3:
			target_pos = Vector2(randf_range(100.0, screen_size.x - 100.0), position.y)
			if target_pos.x <= position.x:
				target_pos.x = randf_range(position.x, screen_size.x - 100.0)
			play("right")

	var distance := position.distance_to(target_pos)
	if distance < 50.0:
		pick_new_target()
		return

	var duration := distance / maxf(swim_speed, 1.0)
	var tween := create_tween()
	tween.tween_property(self, "position", target_pos, duration)
	tween.finished.connect(pick_new_target)

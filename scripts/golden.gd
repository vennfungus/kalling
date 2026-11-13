extends AnimatedSprite2D 

var swim_speed: float = 100.0 
var screen_size: Vector2
var target_pos: Vector2

func _ready():
	screen_size = get_viewport_rect().size
	pick_new_target()

func pick_new_target():
	# 1. CHỌN ĐIỂM ĐÍCH CHỈ THEO 4 HƯỚNG
	var random_direction = randi() % 4 # Chọn ngẫu nhiên 0, 1, 2, hoặc 3
	
	match random_direction:
		0: # Đi lên
			target_pos = Vector2(position.x, randf_range(100, screen_size.y - 100))
			# Để chắc chắn nó đi lên, ta cần đảm bảo target y < position y
			if target_pos.y >= position.y:
				target_pos.y = randf_range(100, position.y)
			play("up")
		1: # Đi xuống
			target_pos = Vector2(position.x, randf_range(100, screen_size.y - 100))
			# Đảm bảo target y > position y
			if target_pos.y <= position.y:
				target_pos.y = randf_range(position.y, screen_size.y - 100)
			play("down")
		2: # Đi sang trái
			target_pos = Vector2(randf_range(100, screen_size.x - 100), position.y)
			# Đảm bảo target x < position x
			if target_pos.x >= position.x:
				target_pos.x = randf_range(100, position.x)
			play("left")
		3: # Đi sang phải
			target_pos = Vector2(randf_range(100, screen_size.x - 100), position.y)
			# Đảm bảo target x > position x
			if target_pos.x <= position.x:
				target_pos.x = randf_range(position.x, screen_size.x - 100)
			play("right")

	# 2. DI CHUYỂN MƯỢT MÀ ĐẾN ĐÍCH
	var distance = position.distance_to(target_pos)
	if distance < 50: 
		# Nếu điểm đích quá gần (hoặc trùng vị trí), bỏ qua và chọn lại
		pick_new_target()
		return
		
	var time_to_reach = distance / swim_speed
	
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, time_to_reach)
	tween.finished.connect(pick_new_target)

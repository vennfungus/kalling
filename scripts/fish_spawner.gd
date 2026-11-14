class_name FishSpawner
extends RefCounted

var fish_database: Array = []

func load_fish_data_from_json() -> void:
	var file := FileAccess.open("res://data/fishes.json", FileAccess.READ)
	if file == null:
		push_error("Fish database file not found: res://data/fishes.json")
		return

	var json_data: Variant = JSON.parse_string(file.get_as_text())
	if not json_data is Array:
		push_error("Fish database must contain a valid JSON array.")
		return

	fish_database = json_data
	print("Successfully loaded data: ", fish_database.size(), " species!")

func spawn_fishes(container: Node2D, amount: int = 5) -> void:
	if fish_database.is_empty():
		push_error("Fish database is empty.")
		return

	for _i in range(amount):
		var fish_info: Variant = fish_database.pick_random()
		if not fish_info is Dictionary:
			push_error("Fish database entries must be JSON objects.")
			continue

		var fish_id := str(fish_info.get("id", ""))
		if fish_id.is_empty():
			push_error("Fish database entry is missing its id.")
			continue

		var scene_path := "res://tscn/fishes/" + fish_id + ".tscn"
		var fish_scene := load(scene_path) as PackedScene
		if fish_scene == null:
			push_error("Fish scene not found: " + scene_path)
			continue

		var fish := fish_scene.instantiate()
		if not fish is Node2D:
			push_error("Fish scene root must be a Node2D: " + scene_path)
			fish.free()
			continue

		fish.position = Vector2(randf_range(100, 600), randf_range(100, 400))
		var fish_scale: float = fish_info.get("scale", 1.0)
		fish.scale = Vector2(fish_scale, fish_scale)
		if "swim_speed" in fish:
			fish.swim_speed = fish_info.get("speed", 40.0)

		container.add_child(fish)

func clear_fishes(container: Node2D) -> void:
	for fish in container.get_children():
		fish.queue_free()

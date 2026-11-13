extends Control

var elapsed := 0.0				# Elapsed time in seconds
var running := false
var fish_database = []
var fishes_active := false

func _ready():
	load_fish_data_from_json()

func load_fish_data_from_json():
	var file = FileAccess.open("res://data/fishes.json", FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		var json_data = JSON.parse_string(json_text) 
		
		if json_data != null:
			fish_database = json_data
			print("Successfully loaded data: ", fish_database.size(), " species!")
		else:
			print("Error: Invalid JSON syntax!")
	else:
		print("Error: JSON file not found!")

func spawn_fishes():
	if fish_database.is_empty():
		print("Error: Fish database is empty!")
		return
		
	for i in range(5):
		# 1. Pick a random fish type from the database
		var fish_info = fish_database.pick_random()
		
		if fish_info == null: 
			continue
			
		# 2. Load the corresponding scene
		var scene_path = "res://tscn/fishes/" + fish_info["id"] + ".tscn"
		var fish_scene = load(scene_path)
		
		if fish_scene == null:
			print("Error: Scene not found at ", scene_path)
			continue
			
		# 3. Instantiate the fish and assign properties
		var fish = fish_scene.instantiate()
		fish.position = Vector2(randf_range(100, 600), randf_range(100, 400))
		
		# Use .get() to provide a default value if the key is missing in JSON
		var fish_scale = fish_info.get("scale", 1.0) 
		fish.scale = Vector2(fish_scale, fish_scale)
		
		if "swim_speed" in fish:
			fish.swim_speed = fish_info.get("speed", 40.0)
		
		add_child(fish)
		move_child(fish, 0)

#---- Timer / Counter Logic ----#
func _process(delta):
	if running:
		elapsed += delta
		update_label()

func update_label():
	var total := int(elapsed)
	var h := total / 3600
	var m := (total % 3600) / 60
	var s := total % 60
	if h > 0:
		$Timer.text = "%02d:%02d:%02d" % [h, m, s]
	else:
		$Timer.text = "%02d:%02d" % [m, s]

func _on_start_pressed():
	running = true

func _on_pause_pressed():
	if running == true:
		running = false
		_lightning($GridContainer/Pause)
		
	elif running == false:
		running = true
		_delightning($GridContainer/Pause)

func _on_reset_pressed():
	get_tree().quit()

func _on_sound_pressed():
	if $SoundPlayer.playing:
		$SoundPlayer.stop() # Nếu đang phát thì dừng lại
		_delightning($GridContainer/Sound) # Tắt đèn nút
	else:
		$SoundPlayer.play() # Nếu chưa phát thì bắt đầu phát
		_lightning($GridContainer/Sound)   # Sáng đèn nút

func _on_record_pressed():
	pass

func _on_fishing_pressed():
	fishes_active = not fishes_active 
	if fishes_active:
		_lightning($GridContainer/Fishing)
		spawn_fishes()
	else:
		_delightning($GridContainer/Fishing)
		clear_fishes()

func clear_fishes():
	# Search for all nodes tagged with "ca_boi" and free them
	get_tree().call_group("ca_boi", "queue_free")

func _lightning(node: Node):
	node.modulate = Color8(135, 206, 235)

func _delightning(node: Node):
	node.modulate = Color(1, 1, 1)

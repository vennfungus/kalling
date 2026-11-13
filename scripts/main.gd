extends Control

var elapsed := 0.0				# Elapsed time in seconds
var running := false
var fishes_active := false
var fish_spawner := FishSpawner.new()

func _ready():
	fish_spawner.load_fish_data_from_json()

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
		$Timer/Label.text = "%02d:%02d:%02d" % [h, m, s]
	else:
		$Timer/Label.text = "%02d:%02d" % [m, s]

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
		fish_spawner.spawn_fishes($FishContainer)
	else:
		_delightning($GridContainer/Fishing)
		fish_spawner.clear_fishes($FishContainer)

func _lightning(node: Node):
	node.modulate = Color8(135, 206, 235)

func _delightning(node: Node):
	node.modulate = Color(1, 1, 1)

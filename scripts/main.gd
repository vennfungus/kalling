extends Control

var elapsed := 0.0				# Elapsed time in seconds
var running := false
var recording := false
var recording_elapsed := 0.0
var fishes_active := false
var muted := false
var show_saved_note := false
var fish_spawner := FishSpawner.new()

func _ready():
	fish_spawner.load_fish_data_from_json()

#---- Timer / Counter Logic ----#
func _process(delta):
	if running:
		elapsed += delta
		update_label()
	if recording:
		recording_elapsed += delta
		update_recording_label()

func update_label():
	if show_saved_note:
		return # Đang hiển thị thông báo thì không đè lên
	$Timer/Label.text = _format_time(elapsed)

func update_recording_label():
	if show_saved_note:
		return # Đang hiển thị thông báo thì không đè lên
	$RecordingLabel.text = "Recording " + _format_time(recording_elapsed)

func _format_time(time_in_seconds: float) -> String:
	var total := int(time_in_seconds)
	var h := total / 3600
	var m := (total % 3600) / 60
	var s := total % 60
	if h > 0:
		return "%02d:%02d:%02d" % [h, m, s]
	return "%02d:%02d" % [m, s]

func _on_start_pressed():
	running = true
	update_label()

func _on_pause_pressed():
	if running == true:
		running = false
		_lightning($GridContainer/Pause)
		
	elif running == false:
		running = true
		_delightning($GridContainer/Pause)

func _on_reset_pressed():
	get_tree().quit()

func _on_mute_pressed():
	muted = not muted
	if muted:
		_lightning($GridContainer/Mute)
	else:
		_delightning($GridContainer/Mute)

func _on_sound_pressed():
	if $SoundPlayer.playing:
		$SoundPlayer.stop() # Nếu đang phát thì dừng lại
		_delightning($GridContainer/Sound) # Tắt đèn nút
	else:
		$SoundPlayer.play() # Nếu chưa phát thì bắt đầu phát
		_lightning($GridContainer/Sound)   # Sáng đèn nút

func _on_record_pressed():
	recording = not recording
	if recording:
		recording_elapsed = 0.0
		$RecordingLabel.visible = true
		update_recording_label()
		_lightning($GridContainer/Record)
	else:
		$RecordingLabel.visible = false
		_delightning($GridContainer/Record)
		# Hiển thị thông báo trên nhãn Record, cùng size/màu/font, trong 1.5s
		show_saved_note = true
		$RecordingLabel.visible = true
		$RecordingLabel.text = "Recording saved"
		await get_tree().create_timer(1.5).timeout
		show_saved_note = false
		$RecordingLabel.visible = false

func _on_fishing_pressed():
	fishes_active = not fishes_active 
	if fishes_active:
		_lightning($GridContainer/Fishing)
		fish_spawner.spawn_fishes($FishContainer)
	else:
		_delightning($GridContainer/Fishing)
		fish_spawner.clear_fishes($FishContainer)

func _lightning(node: Button):
	var highlight := StyleBoxFlat.new()
	highlight.bg_color = Color8(135, 206, 235, 150)
	highlight.corner_radius_top_left = 53
	highlight.corner_radius_top_right = 53
	highlight.corner_radius_bottom_left = 53
	highlight.corner_radius_bottom_right = 53
	for state in ["normal", "hover", "pressed", "hover_pressed", "focus"]:
		node.add_theme_stylebox_override(state, highlight)

func _delightning(node: Button):
	for state in ["normal", "hover", "pressed", "hover_pressed", "focus"]:
		node.remove_theme_stylebox_override(state)
	node.modulate = Color.WHITE

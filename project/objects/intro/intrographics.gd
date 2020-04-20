extends Spatial
tool

export(Array, Texture) var signature_sprites
signal start_game_pressed

var current_sprite = -1;

var y_done = 0
var y_hidden = -10
var opacity_max = 1
var opacity_min = 0

var opactiy_show_speed = 0.33
var opactiy_hide_speed = 0.66

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	
	$start_button/CollisionShape/Sprite3D.modulate = Color.lightcoral
	
	_pick_next_sprite()
	_start_tweens_show();

func _on_sig_visible_timer_timeout():
	$sig_visible_timer.stop()
	_start_tweens_hide();

func _pick_next_sprite():
	current_sprite += 1
	if current_sprite == len(signature_sprites):
		current_sprite = 0
	
	$agameby/signature.texture = signature_sprites[current_sprite]

func _on_sig_hidden_timer_timeout():
	$sig_hidden_timer.stop()
	_pick_next_sprite()
	_start_tweens_show()

func _start_tweens_show():
	# The tweens will both control the position and the opacity
	$sig_opacity_tween.interpolate_property($agameby/signature, "opacity", opacity_min, opacity_max, opactiy_show_speed)
	$sig_opacity_tween.start()
	yield($sig_opacity_tween, "tween_completed")
	$sig_visible_timer.start();

func _start_tweens_hide():
	# The tweens will both control the position and the opacity
	$sig_opacity_tween.interpolate_property($agameby/signature, "opacity", opacity_max, opacity_min, opactiy_hide_speed);
	$sig_opacity_tween.start()
	yield($sig_opacity_tween, "tween_completed")
	$sig_hidden_timer.start();

func _on_Area_mouse_entered():
	# Highlight the sprite
	$start_button/CollisionShape/Sprite3D.modulate = Color.white
	pass # Replace with function body.

func _on_Area_mouse_exited():
	# Stop highlight
	$start_button/CollisionShape/Sprite3D.modulate = Color.lightcoral
	pass # Replace with function body.

func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	# Check for mouse click
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			$sig_opacity_tween.stop_all()
			$sig_hidden_timer.stop()
			$sig_visible_timer.stop()
			emit_signal("start_game_pressed")


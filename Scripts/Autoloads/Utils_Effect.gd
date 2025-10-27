extends Node

var directional_blurr: Shader = load("res://Shaders/directional_blurr.gdshader")

func screenshake(camera: Camera2D, magnitude: float = 8.0, duration: float = 0.18, frequency: float = 30.0) -> void:
	var original_offset = camera.offset
	var elapsed = 0.0
	var shake_interval = 1.0 / frequency
	while elapsed < duration:
		var angle = randf_range(0, PI * 2)
		var strength = randf_range(magnitude * 0.5, magnitude)
		camera.offset = Vector2(cos(angle), sin(angle)) * strength
		await get_tree().create_timer(shake_interval).timeout
		elapsed += shake_interval
	camera.offset = original_offset
	
func apply_directional_blur(sprite, duration: float = 0.3, strength: float = 0.005, angle: float = 0.0):
	if not sprite: 
		return
	var original_material = sprite.material
	var blur_material = ShaderMaterial.new()
	blur_material.shader = directional_blurr
	blur_material.set_shader_parameter("strength", strength)
	blur_material.set_shader_parameter("angle_degrees", angle)
	sprite.material = blur_material
	await get_tree().create_timer(duration).timeout
	sprite.material = original_material

func freeze_frame(freezetime: float = 0.1):
	get_tree().paused = true
	await get_tree().create_timer(freezetime).timeout
	get_tree().paused = false

# Camera Zoom: Zooms in then resets.
func camera_zoom(camera: Camera2D, target_zoom: Vector2 = Vector2(1.2, 1.2), duration: float = 0.2):
	var original_zoom = camera.zoom
	camera.zoom = target_zoom
	await get_tree().create_timer(duration).timeout
	camera.zoom = original_zoom

func color_flash(parent: Node2D, transparency: float, color: Color = Color(1,0,0), duration: float = 0.15):
	var overlay = ColorRect.new()
	var flash_color = color
	flash_color.a = transparency  # Set transparency (0 = invisible, 1 = fully opaque)
	overlay.color = flash_color
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.custom_minimum_size = Vector2(get_viewport().size)
	overlay.anchor_left = 1.0
	overlay.anchor_top = 1.0
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	
	get_tree().current_scene.add_child(overlay)
	
	await get_tree().create_timer(duration).timeout
	overlay.queue_free()

func stretch(sprite: Node2D, duration: float = 0.15, strength: float = 0.18, original_scale: Vector2 = Vector2(1, 1), delay: float = 0.0, ease_type: int = Tween.EASE_OUT):
	var tween = create_tween()
	var stretch_scale = Vector2(original_scale.x - strength, original_scale.y + strength)
	
	if delay > 0.0:
		await get_tree().create_timer(delay).timeout

	tween.tween_property(sprite, "scale", stretch_scale, duration * 0.45).set_ease(ease_type)
	tween.tween_property(sprite, "scale", original_scale, duration * 0.55).set_ease(Tween.EASE_IN)
	await tween.finished

func squash(sprite: Node2D, duration: float = 0.18, strength: float = 0.23, original_scale: Vector2 = Vector2(1, 1), delay: float = 0.0, ease_type: int = Tween.EASE_OUT):
	var tween = create_tween()
	var squash_scale = Vector2(original_scale.x + strength, original_scale.y - strength)

	if delay > 0.0:
		await get_tree().create_timer(delay).timeout

	tween.tween_property(sprite, "scale", squash_scale, duration * 0.4).set_ease(ease_type)
	tween.tween_property(sprite, "scale", original_scale, duration * 0.3).set_ease(Tween.EASE_IN)
	await tween.finished

func lean_run(sprite: Node2D, delta: float, moving_direction: int, lean_strength: float = 9, lean_speed: float = 8.0):
	var target_angle = 0.0

	if moving_direction != 0:
		target_angle = lean_strength * moving_direction
	else:
		target_angle = 0.0
	
	var current_angle = sprite.rotation_degrees
	var new_angle = lerp(current_angle, target_angle, lean_speed * delta)
	sprite.rotation_degrees = new_angle

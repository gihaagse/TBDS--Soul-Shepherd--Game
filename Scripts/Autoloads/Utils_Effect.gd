extends Node

var directional_blurr: Shader = load("res://Shaders/directional_blurr.gdshader")

func damage_effect(player_shader_material: ShaderMaterial) -> void:
	
	if player_shader_material:
		player_shader_material.set_shader_parameter("damage_active", true)
	else:
		print("No shader material")
		return
		
		
	player_shader_material.set_shader_parameter("damage_active", true)
	player_shader_material.set_shader_parameter("damage_time", 1.5)
	player_shader_material.set_shader_parameter("shake_intensity", 1.0)
	player_shader_material.set_shader_parameter("distortion", 0.8)
   
	var tween = create_tween()
	tween.parallel().tween_property(player_shader_material, "shader_parameter/damage_time", 0.0, 0.6)
	tween.parallel().tween_property(player_shader_material, "shader_parameter/shake_intensity", 0.0, 0.4)
	tween.parallel().tween_property(player_shader_material, "shader_parameter/distortion", 0.0, 0.5)
	
	tween.tween_callback(func():
		player_shader_material.set_shader_parameter("damage_active", false)
	)
	

func screenshake(camera: Camera2D, magnitude: float = 8.0, duration: float = 0.18, frequency: float = 30.0) -> void:
	if not camera: return
	
	var original_offset = camera.offset
	var elapsed = 0.0
	var shake_interval = 1.0 / frequency
	while elapsed < duration:
		if not camera: return
		var angle = randf_range(0, PI * 2)
		var strength = randf_range(magnitude * 0.5, magnitude)
		camera.offset = Vector2(cos(angle), sin(angle)) * strength
		await get_tree().create_timer(shake_interval).timeout
		elapsed += shake_interval
	camera.offset = original_offset
	
func apply_directional_blur(sprite, duration: float = 0.3, strength: float = 0.005, angle: float = 0.0):
	if not sprite: return
	
	var original_material = sprite.material
	var blur_material = ShaderMaterial.new()
	blur_material.shader = directional_blurr
	blur_material.set_shader_parameter("strength", strength)
	blur_material.set_shader_parameter("angle_degrees", angle)
	sprite.material = blur_material
	await get_tree().create_timer(duration).timeout
	blur_material.set_shader_parameter("strength", 0)
	if sprite and sprite.material:
		sprite.material = original_material if original_material else null

func freeze_frame(freezetime: float = 0.1):
	get_tree().paused = true
	await get_tree().create_timer(freezetime).timeout
	get_tree().paused = false

func camera_zoom(camera: Camera2D, target_zoom: Vector2 = Vector2(1.2, 1.2), duration: float = 0.2):
	if not camera: return
	
	var original_zoom = Vector2(4.0, 4.0)
	camera.zoom = target_zoom
	await get_tree().create_timer(duration).timeout
	camera.zoom = original_zoom

func color_flash(parent: Node2D, transparency: float, color: Color = Color(1,0,0), duration: float = 0.15):
	if not parent: return
	
	var overlay = ColorRect.new()
	var flash_color = color
	flash_color.a = transparency  
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
	if not sprite: return
	
	var tween = create_tween()
	var stretch_scale = Vector2(original_scale.x - strength, original_scale.y + strength)
	
	if delay > 0.0:
		await get_tree().create_timer(delay).timeout

	tween.tween_property(sprite, "scale", stretch_scale, duration * 0.45).set_ease(ease_type)
	tween.tween_property(sprite, "scale", original_scale, duration * 0.55).set_ease(Tween.EASE_IN)
	await tween.finished

func squash(sprite: Node2D, duration: float = 0.18, strength: float = 0.23, original_scale: Vector2 = Vector2(1, 1), delay: float = 0.0, ease_type: int = Tween.EASE_OUT):
	if not sprite: return
	
	var tween = create_tween()
	var squash_scale = Vector2(original_scale.x + strength, original_scale.y - strength)

	if delay > 0.0:
		await get_tree().create_timer(delay).timeout

	tween.tween_property(sprite, "scale", squash_scale, duration * 0.4).set_ease(ease_type)
	tween.tween_property(sprite, "scale", original_scale, duration * 0.3).set_ease(Tween.EASE_IN)
	await tween.finished

func lean_run(sprite: Node2D, delta: float, moving_direction: int, lean_strength: float = 9, lean_speed: float = 8.0):
	if not sprite: return
	
	var target_angle = 0.0

	if moving_direction != 0:
		target_angle = lean_strength * moving_direction
	else:
		target_angle = 0.0
	
	var current_angle = sprite.rotation_degrees
	var new_angle = lerp(current_angle, target_angle, lean_speed * delta)
	sprite.rotation_degrees = new_angle

func dash_effect(character: CharacterBody2D, enable: bool, direction: float = 0):
	if not character:
		return
	
	var dash_lines : Node2D = character.get_node("DashLines")
	var dash_smoke : Node2D = character.get_node("DashSmoke")
	if not dash_lines or not dash_smoke: return
	
	var bLines: GPUParticles2D = dash_lines.get_node("DashLinesParticleB")
	var wLines: GPUParticles2D = dash_lines.get_node("DashLinesParticleW")
	var round_smoke: GPUParticles2D = dash_smoke.get_node("RoundSmoke")
	if not bLines or not wLines or not round_smoke: return
	
	if enable:
		if not direction == 0:
			var bMaterial = bLines.process_material as ParticleProcessMaterial
			var wMaterial = wLines.process_material as ParticleProcessMaterial
			var smokeMaterial = round_smoke.process_material as ParticleProcessMaterial
			if bMaterial and wMaterial and smokeMaterial:
				bMaterial.direction.x = direction * -1
				wMaterial.direction.x = direction * -1
				bLines.position.x = -6.0 if direction < 0 else 6.0
				wLines.position.x = -6.0 if direction < 0 else 6.0
				
				smokeMaterial.direction.x = direction * -1
				round_smoke.position.x = 17.0 if direction < 0 else -17.0
			bLines.emitting = true
			wLines.emitting = true
			round_smoke.emitting = true
	else:
		bLines.emitting = false
		wLines.emitting = false

func apply_knockback(character: CharacterBody2D, direction: float, strength: float):
	var knockback_velocity = Vector2.from_angle(direction) * strength
	character.velocity = knockback_velocity
	character.velocity.y = -165.0
	
	character.move_and_slide()

func shake_sprite(target: Node2D, duration: float = 0.25, intensity: float = 2.5, speed: float = 20.0) -> void:
	if target == null or not is_instance_valid(target):
		return
	
	var original_pos: Vector2 = target.position
	
	# Create tween ON the target instead of on the tree
	var tween := target.create_tween()
	tween.set_parallel(true)
	
	tween.tween_method(
		func(t: float) -> void:
			if not is_instance_valid(target):
				return  # target got freed → do nothing
			var decay := 1.0 - t
			var offset := Vector2(
				randf_range(-1.0, 1.0),
				randf_range(-0.5, 0.5)
			) * intensity * decay
			target.position = original_pos + offset,
		0.0, 1.0, duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.tween_callback(
		func() -> void:
			if is_instance_valid(target):
				target.position = original_pos
	).set_delay(duration)
	
func fade_sprite(target: CanvasItem, duration: float = 0.4, to_alpha: float = 0.0) -> void:
	if target == null or not is_instance_valid(target):
		return
	
	var tween := get_tree().create_tween()
	
	# Zorg dat we van de huidige alpha naar to_alpha gaan
	var start_color: Color = target.modulate
	var end_color: Color = start_color
	end_color.a = clamp(to_alpha, 0.0, 1.0)
	
	tween.tween_property(
		target,
		"modulate",
		end_color,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

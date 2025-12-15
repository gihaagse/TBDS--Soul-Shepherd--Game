extends Obstacle

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var sprite : Sprite2D = $MainSpirte
	if sprite.modulate.a <= 0.0:
		#await get_tree().create_timer(active_for/10).timeout
		remove_trap()

func check(body: Node2D) -> void:
	if counter_used >= one_time_use:
		disable_trap()
		return
	
	if not is_enabled:
		if is_triggered:
			is_triggered = false
		return
	
	if is_triggered: return # nothing needs to happen since it's already triggered
	
	is_triggered = true
	counter_used += 1 # increase counter
	start(body)

func start(body: Node2D) -> void:
	await get_tree().create_timer(activation_delay).timeout # if trap should be delayed
	
	if body.is_in_group(player_group):
		var player: Player = body
		
		for effect in effect_type:
			apply_effects(player, effect)
	
	if reuse_cooldown > 0.0:
		await get_tree().create_timer(reuse_cooldown).timeout
		_on_trigger_ended()
	

func apply_effects(player: Player, effect_type : EffectTypes):
	match effect_type:
		EffectTypes.FALLING_TILE:
			UtilsEffect.shake_sprite($MainSpirte, active_for - .5)
			await get_tree().create_timer(.5).timeout 
			UtilsEffect.fade_sprite($MainSpirte, active_for - 1.0)
		_:
			pass
		
func _on_falling_tile_effects_ended():
		is_enabled = false
		is_triggered = false

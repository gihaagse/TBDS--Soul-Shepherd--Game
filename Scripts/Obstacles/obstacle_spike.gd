extends Obstacle

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass
	
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
	$Spikes.position.y -= 20
	
	await get_tree().create_timer(active_for).timeout # how long it should stay active
	$Spikes.position.y = 0
	is_triggered = false
	
	await get_tree().create_timer(reuse_cooldown).timeout
	_on_trigger_ended()
	

func apply_effects(player: Player, effect_type : EffectTypes):
	match effect_type:
		EffectTypes.DAMAGE:
			print("DOING DAMAGE")
			player.hp.take_damage(damage_trap)
			print(damage_trap)
		EffectTypes.KNOCKBACK:
			var dir := _get_knockback_dir(player)
			var angle := dir.angle()
			UtilsEffect.apply_knockback(player, angle, 200)
			call_deferred("_gravity_timer", player)
		EffectTypes.SLOW:
			pass
		_:
			pass
func _gravity_timer(player: Player) -> void:
	var state = player.finite_state_machine._get_current_state()
	state.custom_gravity = Vector2(0,100)
	await get_tree().create_timer(.25).timeout
	state.custom_gravity = Vector2(0,980)

func _on_spikes_body_entered(player: Player) -> void:
	if not is_triggered: return
	if not player.is_in_group(player_group): return
	
	#check which 
	for effect in effect_type:
		apply_effects(player, effect)

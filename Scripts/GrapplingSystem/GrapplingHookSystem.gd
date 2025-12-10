extends Node2D
class_name GHS

signal attachment

@export var grapple_anchor: Node
@export var player_anchor: RigidBody2D
@export var rope: Line2D

@export var max_radius: float = 512

var player_original_parent: Node = null
@export var player_ref: Node2D
@export var grapple_state : Player_Grapple
var pull_me : bool = false
var is_grappling : bool = false
var can_grapple : bool = false
var pull_pos : Vector2


func _ready():
	rope.visible = false
	rope.default_color = Color("#ffffff00")
	player_anchor.visible = false
	grapple_state = player_ref.get_node_or_null("FiniteStateMachine").get_node_or_null("Grapple")


func _physics_process(delta):
	if not rope.visible:
		return

	# Swing input (adds impulses to player anchor)
	if Input.is_action_pressed("Right") and player_anchor.global_position.y > grapple_anchor.global_position.y:
		if player_anchor.linear_velocity.length() < 400:
			player_anchor.apply_central_impulse(player_anchor.global_transform.x * 64)
	elif Input.is_action_pressed("Left") and player_anchor.global_position.y > grapple_anchor.global_position.y:
		if player_anchor.linear_velocity.length() < 400:
			player_anchor.apply_central_impulse(player_anchor.global_transform.x * -64)

	# Update rope positions
	rope.points[0] = rope.to_local(grapple_anchor.global_position)
	rope.points[1] = rope.to_local(player_anchor.global_position)
	
	if pull_me:
		player_anchor.global_position = pull_pos
		rope.points[0] = rope.to_local(grapple_anchor.global_position)
		rope.points[1] = rope.to_local(player_anchor.global_position)
		rope.default_color = Color("#ffffff")
		pull_me = false
	
	# Keep any children of player_anchor centered
	for child in player_anchor.get_children():
		if "position" in child:
			child.position = Vector2.ZERO
			
			
func try_grapple_at(target_pos: Vector2):
	var from_pos = player_ref.global_position
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from_pos, target_pos)
	var result = space_state.intersect_ray(query)

	if result and result.collider and from_pos.distance_to(result.position) <= max_radius:
		grapple_anchor.global_position = result.position
		if attach_player(player_ref) == 0:
			is_grappling = true
			pass
	else:
		detach_player(player_ref)
		is_grappling = false

#func _input(event):
	#if player_ref == null:
		#return
#
	## Left-click: try to grapple
	#if not is_grappling and Input.is_action_just_pressed("Grapple") and can_grapple:
		##var mouse_pos = get_global_mouse_position()
		##var space_state = get_world_2d().direct_space_state
##
		### Create query parameters
		##var query = PhysicsPointQueryParameters2D.new()
		##query.position = mouse_pos
		##query.collide_with_areas = true
		##query.collide_with_bodies = true
		##query.collision_mask = 0x7FFFFFFF
##
		### Perform the intersection
		##var result = space_state.intersect_point(query, 32)
##
		##if result.size() > 0:
			##var collider = result[0].collider
			##print("Clicked:", collider.name)
		#try_grapple_at(get_global_mouse_position())
		#player_ref.global_rotation = 0
		#print("go")
#
	## Right-click: detach
	#elif is_grappling and Input.is_action_just_pressed("Grapple"):
		#if is_grappling:
			#detach_player(player_ref)
			#player_ref.global_rotation = 0
			#is_grappling = false
			
func attach_player(player: Node2D) -> int:
	if grapple_anchor.global_position.distance_to(player.global_position) > max_radius or player_original_parent != null:
		return -1

	player_original_parent = player.get_parent()

	# Temporarily disable physics simulation so we can safely reposition
	pull_pos = player.global_position

	player.reparent(player_anchor)
	#player.position = Vector2.ZERO

	player_anchor.linear_velocity = Vector2.ZERO
	player_anchor.angular_velocity = 0.0

	rope.visible = true
	player_anchor.visible = true
	player_ref = player
	pull_me = true
	return 0

func detach_player(player: Node2D) -> int:
	if player_original_parent == null:
		return -1

	player.reparent(player_original_parent)
	if "velocity" in player:
		player.velocity = player_anchor.linear_velocity

	player_original_parent = null
	rope.visible = false
	player_anchor.visible = false
	return 0

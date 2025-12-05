extends Camera2D
class_name CameraMain

@export var player: CharacterBody2D

@export var border_vertical_layer: int = 9
@export var border_horizontal_layer: int = 10

@export var follow_speed := 5.0
@export var base_offset := Vector2(30, 0)

@export var horizontal_ray_distance := 80.0
@export var vertical_ray_distance := 30.0

@export var ground_cam_offset := -50.0
@export var ceiling_cam_offset := 40.0

@export var left_cam_offset := 60.0
@export var right_cam_offset := -90.0

@export var offset_lerp_speed := 10.0 

var target_pos: Vector2

var left_ray: RayCast2D
var right_ray: RayCast2D
var top_ray: RayCast2D
var bottom_ray: RayCast2D

var current_horizontal_offset := 0.0
var target_horizontal_offset := 0.0

var current_vertical_offset := 0.0
var target_vertical_offset := 0.0


func _ready() -> void:
	if player == null:
		return
	if not player.has_node("Border_RayCasts"):
		push_error("Player mist Border_RayCasts node")
		return
	_create_raycasts()
	CheckPointManager.register_camera(self)


func _create_raycasts() -> void:
	var parent := player.get_node("Border_RayCasts")

	for child in parent.get_children():
		if child is RayCast2D and child.name.begins_with("Ray"):
			child.queue_free()

	var mask_V := 1 << border_vertical_layer
	var mask_H := 1 << border_horizontal_layer

	left_ray = RayCast2D.new()
	left_ray.name = "RayLeft"
	left_ray.target_position = Vector2(-horizontal_ray_distance, 0)
	left_ray.collision_mask = mask_H
	left_ray.enabled = true
	parent.add_child(left_ray)

	right_ray = RayCast2D.new()
	right_ray.name = "RayRight"
	right_ray.target_position = Vector2(horizontal_ray_distance, 0)
	right_ray.collision_mask = mask_H
	right_ray.enabled = true
	parent.add_child(right_ray)

	top_ray = RayCast2D.new()
	top_ray.name = "RayTop"
	top_ray.target_position = Vector2(0, -vertical_ray_distance)
	top_ray.collision_mask = mask_V
	top_ray.enabled = true
	parent.add_child(top_ray)

	bottom_ray = RayCast2D.new()
	bottom_ray.name = "RayBottom"
	bottom_ray.target_position = Vector2(0, vertical_ray_distance)
	bottom_ray.collision_mask = mask_V
	bottom_ray.enabled = true
	parent.add_child(bottom_ray)


func _process(delta: float) -> void:
	if player == null:
		return

	target_pos = player.global_position + base_offset

	_update_horizontal_offset_targets()
	_update_vertical_offset_targets()

	current_horizontal_offset = lerpf(
		current_horizontal_offset,
		target_horizontal_offset,
		offset_lerp_speed * delta
	)

	current_vertical_offset = lerpf(
		current_vertical_offset,
		target_vertical_offset,
		offset_lerp_speed * delta
	)

	target_pos.x += current_horizontal_offset
	target_pos.y += current_vertical_offset

	global_position = global_position.lerp(target_pos, follow_speed * delta)


func _update_horizontal_offset_targets() -> void:
	var hit_left := left_ray.is_colliding()
	var hit_right := right_ray.is_colliding()

	if hit_left and not hit_right:
		target_horizontal_offset = left_cam_offset
	elif hit_right and not hit_left:
		target_horizontal_offset = right_cam_offset
	else:
		target_horizontal_offset = 0.0


func _update_vertical_offset_targets() -> void:
	var hit_bottom := bottom_ray.is_colliding()
	var hit_top := top_ray.is_colliding()

	if hit_bottom and not hit_top:
		target_vertical_offset = ground_cam_offset
	elif hit_top and not hit_bottom:
		target_vertical_offset = ceiling_cam_offset
	else:
		target_vertical_offset = 0.0


func _on_respawn() -> void:
	if player != null:
		target_pos = player.global_position + base_offset

		current_horizontal_offset = 0.0
		target_horizontal_offset = 0.0
		current_vertical_offset = 0.0
		target_vertical_offset = 0.0

		global_position = target_pos

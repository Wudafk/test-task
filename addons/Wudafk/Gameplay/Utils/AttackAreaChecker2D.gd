class_name AttackAreaChecker2D

static func CheckArcCollision2(
	arcDamageAreaData: ArcDamageAreaData,
	collision_mask: int,
	exclude_bodies: Array = [],
	max_results: int = 32
) -> Array:
	return CheckArcCollision((arcDamageAreaData as Node as Node2D).get_world_2d(), arcDamageAreaData as Node as Node2D, arcDamageAreaData.arcData, collision_mask, exclude_bodies, max_results)

static func CheckArcCollision(
	world: World2D,
	attacker_node: Node2D,
	arcData: ArcData,
	collision_mask: int,
	exclude_bodies: Array = [],
	max_results: int = 32
) -> Array:
	var results: Array = []
	var space_state = world.direct_space_state

	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = CircleShape2D.new()
	query.shape.radius = arcData.arcRadius
	query.transform = attacker_node.global_transform
	query.exclude = exclude_bodies
	query.collision_mask = collision_mask
	query.collide_with_bodies = true
	query.collide_with_areas = false
	
	var overlap_results = space_state.intersect_shape(query, max_results)

	var arc_angle_start_deg_relative = arcData.arcAngleStartDeg
	var arc_angle_end_deg_relative = arcData.arcAngleEndDeg
	
	var attacker_global_rotation_rad = attacker_node.global_rotation
	
	var is_flipped_horizontally: bool = attacker_node.scale.x < 0

	var corrected_start_deg: float = arc_angle_start_deg_relative
	var corrected_end_deg: float = arc_angle_end_deg_relative
	
	if is_flipped_horizontally:
		corrected_start_deg = -arc_angle_start_deg_relative + 180.0
		corrected_end_deg = -arc_angle_end_deg_relative + 180.0
		
		if corrected_start_deg > corrected_end_deg:
			var temp = corrected_start_deg
			corrected_start_deg = corrected_end_deg
			corrected_end_deg = temp

	var arc_start_abs_rad = deg_to_rad(corrected_start_deg) + attacker_global_rotation_rad
	var arc_end_abs_rad = deg_to_rad(corrected_end_deg) + attacker_global_rotation_rad

	arc_start_abs_rad = wrapf(arc_start_abs_rad, -PI, PI)
	arc_end_abs_rad = wrapf(arc_end_abs_rad, -PI, PI)

	var arc_full_span_deg = abs(arc_angle_end_deg_relative - arc_angle_start_deg_relative)
	var arc_half_span_rad = deg_to_rad(arc_full_span_deg / 2.0)
	
	var start_vector = Vector2.RIGHT.rotated(arc_start_abs_rad)
	var end_vector = Vector2.RIGHT.rotated(arc_end_abs_rad)
	
	var middle_vector = (start_vector + end_vector).normalized()
	var arc_middle_abs_rad = middle_vector.angle()
	
	arc_middle_abs_rad = wrapf(arc_middle_abs_rad, -PI, PI)

	for res in overlap_results:
		var collider: Node2D = res.collider
		if collider == null: continue

		var direction_to_collider = collider.global_position - attacker_node.global_position
		
		if direction_to_collider.length_squared() < 0.0001:
			continue

		var angle_to_collider_abs_rad = direction_to_collider.angle()
		angle_to_collider_abs_rad = wrapf(angle_to_collider_abs_rad, -PI, PI)

		var delta_angle = wrapf(angle_to_collider_abs_rad - arc_middle_abs_rad, -PI, PI)
		
		if abs(delta_angle) <= arc_half_span_rad:
			results.append(res)
				
	return results

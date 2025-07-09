@tool
class_name AttackArcDebugger2D extends Node2D

@export var _arcDamageAreaData: ArcDamageAreaData

var arc_radius: float:
	get:
		return _arcDamageAreaData.arcData.arcRadius if _arcDamageAreaData else 0.0
var arc_angle_start: float:
	get:
		return _arcDamageAreaData.arcData.arcAngleStartDeg if _arcDamageAreaData else 0.0
var arc_angle_end: float:
	get:
		return _arcDamageAreaData.arcData.arcAngleEndDeg if _arcDamageAreaData else 0.0

@export var arc_segments: int = 16:
	set(value):
		arc_segments = max(3, value)
		queue_redraw()
@export var arc_color: Color = Color.RED:
	set(value):
		arc_color = value
		queue_redraw()

@export var draw_in_game: bool = false:
	set(value):
		draw_in_game = value
		queue_redraw()

@export var arc_line_thickness: float = 2.0

@export var is_flipped_horizontally: bool = false

func _ready():
	if not Engine.is_editor_hint():
		var should_be_visible = draw_in_game
		
		visible = should_be_visible
		if not should_be_visible:
			set_process(false)
	
	queue_redraw()

func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()
		return

	if draw_in_game:
		queue_redraw()
	else:
		visible = false

func _draw():
	if not Engine.is_editor_hint() and not draw_in_game:
		return
	if _arcDamageAreaData == null:
		return

	var center = Vector2.ZERO
	var current_node_rotation_rad = rotation 
	
	var arc_angle_start_deg_relative = arc_angle_start
	var arc_angle_end_deg_relative = arc_angle_end
	
	var original_arc_middle_deg = (arc_angle_start_deg_relative + arc_angle_end_deg_relative) / 2.0
	var original_arc_half_span_deg = abs(arc_angle_end_deg_relative - arc_angle_start_deg_relative) / 2.0

	var corrected_arc_middle_deg: float = original_arc_middle_deg
	if is_flipped_horizontally:
		corrected_arc_middle_deg = -original_arc_middle_deg + 180.0
	
	corrected_arc_middle_deg = wrapf(corrected_arc_middle_deg, -180.0, 180.0)

	var draw_middle_rad = deg_to_rad(corrected_arc_middle_deg) + current_node_rotation_rad
	var draw_half_span_rad = deg_to_rad(original_arc_half_span_deg)
	
	var draw_start_rad = draw_middle_rad - draw_half_span_rad
	var draw_end_rad = draw_middle_rad + draw_half_span_rad
	
	draw_arc(center, arc_radius, draw_start_rad, draw_end_rad, arc_segments, arc_color, arc_line_thickness, true)

	var start_point_on_arc = center + Vector2(arc_radius, 0).rotated(draw_start_rad)
	draw_line(center, start_point_on_arc, arc_color, arc_line_thickness, true)

	var end_point_on_arc = center + Vector2(arc_radius, 0).rotated(draw_end_rad)
	draw_line(center, end_point_on_arc, arc_color, arc_line_thickness, true)

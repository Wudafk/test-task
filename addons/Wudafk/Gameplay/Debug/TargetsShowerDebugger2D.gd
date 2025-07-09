@tool
class_name TargetsShowerDebugger2D extends Node2D

@export var _arcDamageAreaData: ArcDamageAreaData

@export var draw_in_game: bool = false:
	set(value):
		draw_in_game = value
		queue_redraw()

@export var hit_line_color: Color = Color.GREEN
@export var hit_line_thickness: float = 0.1
@export var hit_lines_duration: float = 0.2
@export var collision_mask: int = 1

var _targets_to_draw: Array[Vector2] = []
var _hit_lines_display_timer: float = 0.0

func _ready():
	if not Engine.is_editor_hint():
		var should_be_visible = draw_in_game
		
		visible = should_be_visible
		if not should_be_visible:
			set_process(false)
	
	queue_redraw()

func _process(delta):
	if Engine.is_editor_hint():
		_find_and_draw_targets()
		queue_redraw()
		return

	if draw_in_game:
		_find_and_draw_targets() 
		
		if _hit_lines_display_timer > 0:
			_hit_lines_display_timer -= delta
			if _hit_lines_display_timer <= 0:
				_targets_to_draw.clear()
			queue_redraw()
	else:
		visible = false

func _find_and_draw_targets():
	if not Engine.is_editor_hint() and not draw_in_game:
		return

	if _arcDamageAreaData == null:
		_targets_to_draw.clear()
		return

	var attacker_node: Node2D = owner as Node2D
	if not is_instance_valid(attacker_node):
		_targets_to_draw.clear()
		printerr("ArcVisualizer2D: Owner is not a valid Node2D for attack checks.")
		return

	var excluded_from_targets: Array = [attacker_node]

	var world: World2D = get_world_2d()
	if world == null:
		_targets_to_draw.clear()
		printerr("ArcVisualizer2D: Could not get World2D. Is this node in the SceneTree?")
		return

	var results = AttackAreaChecker2D.CheckArcCollision(
		world,
		get_parent(),
		_arcDamageAreaData.arcData,
		collision_mask,
		excluded_from_targets
	)
	
	_targets_to_draw.clear()
	for res in results:
		var collider: Node2D = res.collider
		if is_instance_valid(collider):
			_targets_to_draw.append(collider.global_position)
	
	if _targets_to_draw.size() > 0:
		_hit_lines_display_timer = hit_lines_duration

	queue_redraw()

func _draw():
	if not Engine.is_editor_hint() and not draw_in_game:
		return
	if _arcDamageAreaData == null:
		return

	var center = Vector2.ZERO

	if _targets_to_draw.size() > 0 and _hit_lines_display_timer > 0:
		for target_global_pos in _targets_to_draw:
			var target_local_pos = to_local(target_global_pos + Vector2(0, -50)) 
			draw_line(center, target_local_pos, hit_line_color, hit_line_thickness, true)

class_name ObserverCamera2D extends Node2D

@export var camera_mount: Node2D
@export var camera_2d_node: Camera2D

@export var follow_speed: float = 5.0
@export var zoom_level: float = 1.0
@export var zoom_speed: float = 2.0

@export var limit_left: int = 0
@export var limit_top: int = 0
@export var limit_right: int = 1000
@export var limit_bottom: int = 500

func _ready():
	if not is_instance_valid(camera_2d_node):
		printerr("ObserverCamera2D: 'camera_2d_node' не назначен!")
		return
	
	camera_2d_node.make_current() 
	camera_2d_node.enabled = true
	
	_apply_camera_limits()
	camera_2d_node.zoom = Vector2.ONE * zoom_level


func _physics_process(delta: float):
	if is_instance_valid(camera_mount):
		set_look_at_position(camera_mount.global_position, delta)
	
	if camera_2d_node.zoom.x != zoom_level:
		camera_2d_node.zoom.x = lerp(camera_2d_node.zoom.x, zoom_level, delta * zoom_speed)
		camera_2d_node.zoom.y = lerp(camera_2d_node.zoom.y, zoom_level, delta * zoom_speed)

func set_look_at_position(target_position: Vector2, delta: float):
	camera_2d_node.global_position = camera_2d_node.global_position.lerp(target_position, delta * follow_speed)
	
	_apply_camera_limits()


func _apply_camera_limits():
	camera_2d_node.limit_left = limit_left
	camera_2d_node.limit_top = limit_top
	camera_2d_node.limit_right = limit_right
	camera_2d_node.limit_bottom = limit_bottom

func set_zoom_level(new_zoom: float):
	zoom_level = new_zoom

func _rotate_sprite_to_look_at_target(sprite_to_rotate: Sprite2D, look_at_target_position: Vector2):
	var direction = (look_at_target_position - sprite_to_rotate.global_position).normalized()
	sprite_to_rotate.rotation = direction.angle()

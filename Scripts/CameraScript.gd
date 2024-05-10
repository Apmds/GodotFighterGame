@tool

class_name GameCamera extends Camera2D

@export var start_position : Vector2 = Vector2(320, 180)
var focused_node : Node = null
var focus_zoom : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	position = start_position

# Shakes the camera with some intensity for some number of frames
func shake(frames : int = 15, intensity : float = 5.0) -> void:
	for i in range(frames):
		offset = Vector2(randf_range(-1.0, 1.0) * intensity, randf_range(-1.0, 1.0) * intensity)
		await get_tree().process_frame

# Zooms into the desired node for the desired time in seconds
func zoom_into(node : Node, zoom_level : float = 1.2, time : float = 0.2):
	focused_node = node
	focus_zoom = zoom_level
	
	await get_tree().create_timer(time).timeout
	
	focused_node = null
	focus_zoom = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint():
		position = start_position
	else:
		zoom = Vector2(lerp(zoom.x, focus_zoom, 0.1), lerp(zoom.y, focus_zoom, 0.1))
		if focused_node != null:
			position = focused_node.position
		else:
			position = start_position

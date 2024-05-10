class_name Hitbox extends Area2D

signal attack_landed(body, area)

var length : int = 1				# Length in frames (at 60 fps, scaled to the actual framerate during animation)
var window_number : int = 0
var shape : int = 0
var width : int = 10
var height : int = 10
var position_x : float = 0
var position_y : float = 0
var damage : int = 50
var type : int = 0					# 0 for normal hitbox, 1 for projecile
var velocity_x : float = 0
var velocity_y : float = 0
var direction : int = 1
var sprite_name : String = ""
var current_frame : float = 0
var anim_speed : float = 0.2
var player : Character				# The player whose this hitbox belongs to

var current_length : int = length

var sprite_node : Sprite2D

func _init(plr : Character):
	player = plr

func _ready() -> void:
	body_entered.connect(_on_body_entered)

# Animates cycling animations; returns true if the animation just looped
func cycle_animate() -> bool:
	current_frame += anim_speed
	
	if current_frame >= sprite_node.hframes - 1:
		current_frame = 0

	if int(current_frame) > sprite_node.hframes - 1:
		current_frame = sprite_node.hframes - 1
	
	sprite_node.frame = int(current_frame)

	return current_frame > sprite_node.hframes - 1

# Creates and sets the collision and sprite
func activate(obj : Character) -> void:
	if not attack_landed.is_connected(obj._on_attack_landed):
		attack_landed.connect(obj._on_attack_landed)

	# Collision
	var hitbox_collision : CollisionShape2D = CollisionShape2D.new()

	# Shape
	if shape == 1:
		hitbox_collision.shape = CircleShape2D.new()
		hitbox_collision.shape.radius = width
	else:
		hitbox_collision.shape = RectangleShape2D.new()
		hitbox_collision.shape.size = Vector2(width, height)

	add_child(hitbox_collision)
	
	if type == 1:
		if sprite_name != "":
			# Sprite
			var hitbox_sprite : Sprite2D = Sprite2D.new()

			hitbox_sprite.texture = obj.sprites.get(sprite_name)[0]
			hitbox_sprite.hframes = obj.sprites.get(sprite_name)[1]
			hitbox_sprite.flip_h = (direction == -1)

			add_child(hitbox_sprite)
			sprite_node = hitbox_sprite
	
		obj.owner.add_child(self)
	else:
		obj.add_child(self)

func _physics_process(delta : float) -> void:
	if type == 1:
		global_position.x += velocity_x * delta * direction
		global_position.y += velocity_y * delta
		if sprite_name != "":
			cycle_animate()

	current_length -= 1
	if current_length == 0:
		current_length = length
		if player.state != Character.State.HIT:
			player.missed_attack = true
		queue_free()
		#get_parent().remove_child(self)
		#for child in get_children():
		#	if child is CollisionShape2D:
		#		remove_child(child)

func _on_body_entered(body):
	attack_landed.emit(body, self)

# Returns a hitbox with the same variables as this
func clone() -> Hitbox:
	var new_hitbox = Hitbox.new(player)
	new_hitbox.length = length
	new_hitbox.window_number = window_number
	new_hitbox.shape = shape
	new_hitbox.width = width
	new_hitbox.height = height
	new_hitbox.position_x = position_x
	new_hitbox.position_y = position_y
	new_hitbox.damage = damage
	new_hitbox.type = type
	new_hitbox.velocity_x = velocity_x
	new_hitbox.velocity_y = velocity_y
	new_hitbox.direction = direction
	new_hitbox.sprite_name = sprite_name
	new_hitbox.current_frame = current_frame
	new_hitbox.anim_speed = anim_speed

	new_hitbox.current_length = length

	return new_hitbox

# OLD IMPLEMENTATION
#enum HitboxParams {
#	LENGTH,         # Length in frames (at 60 fps, scaled to the actual framerate during animation)
#	WINDOW_NUM,
#	SHAPE,          # 0 for square, 1 for circle (radius = WIDTH)
#	WIDTH,
#	HEIGHT,
#	POSITION_X,
#	POSITION_Y,
#	DAMAGE,
#	TYPE,           # 0 for normal hitbox, 1 for projecile
#	VELOCITY_X,
#	VELOCITY_Y,
#
#}
#
#var params = {
#	HitboxParams.LENGTH : 1,
#	HitboxParams.WINDOW_NUM : 0,
#	HitboxParams.SHAPE : 0,
#	HitboxParams.WIDTH : 10,
#	HitboxParams.HEIGHT : 10,
#	HitboxParams.POSITION_X : 0,
#	HitboxParams.POSITION_Y : 0,
#	HitboxParams.DAMAGE : 50,
#	HitboxParams.TYPE : 0,
#	HitboxParams.VELOCITY_X: 0,
#	HitboxParams.VELOCITY_Y: 0,
#}
#
#func set_param(param : HitboxParams, value) -> void:
#	params[param] = value
#
#func get_param(param : HitboxParams):
#	return params[param]

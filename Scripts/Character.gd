class_name Character extends CharacterBody2D

class Attack:
	var windows : Array[AttackWindow] = []
	var hitboxes : Array[Hitbox] = []

	var sprite_name : String = "WeakAttack"
	var sprite_frames : int = 0
	var playing = false

	# NOT USED
	func start_play(obj : Character):
		if !playing:
			playing = true
			obj.current_attack = self
			

	func play(obj : Character):
		if !playing:
			playing = true
			obj.current_attack = self

		var window_num = -1
		for window in windows:
			window_num += 1

			# Set the starting frame of the window
			obj.set_sprite(sprite_name)
			var frame_offset = window.params.get(AttackWindow.WindowParams.START_FRAME)
			obj.current_frame = frame_offset

			var velocity_vector = Vector2(window.get_param(AttackWindow.WindowParams.VELOCITY_X), window.get_param(AttackWindow.WindowParams.VELOCITY_Y))
			if window.get_param(AttackWindow.WindowParams.VELOCITY_TYPE) == 0:
				obj.velocity = velocity_vector * Vector2((-1)**int(obj.sprite_node.flip_h), 1)
			else:
				obj.velocity += velocity_vector * Vector2((-1)**int(obj.sprite_node.flip_h), 1)

			# Length of the window converted from 60 fps to the current fps
			var fps = Engine.get_frames_per_second()
			var length = (float(fps)/float(60)) * window.params.get(AttackWindow.WindowParams.LENGTH)
			if obj.missed_attack:
				obj.missed_attack = false
				if window.params.get(AttackWindow.WindowParams.HAS_WHIFFLAG):
					length *= 1.5
			#print("\nLength: " + str(length))
			
			# How much time(in frames) each frame of animation can be on screen
			var frame_time : float = float(length)/float(window.params.get(AttackWindow.WindowParams.NUM_FRAMES))
			
			#print("Frame_time: " + str(frame_time))

			# Setting attack hitbox
			for hitbox in hitboxes:
				if hitbox.window_number == window_num:
					var new_hitbox = hitbox.clone()

					# Setting direction
					if new_hitbox.type == 1:
						new_hitbox.direction = (-1)**int(obj.sprite_node.flip_h)

					new_hitbox.activate(obj)
					
					# Position
					new_hitbox.global_position = Vector2(new_hitbox.position_x * (-1)**int(obj.sprite_node.flip_h), new_hitbox.position_y) + obj.global_position

			# Playing animation
			for i in range(length):
				if !playing:
					break

				var ft = int(frame_time)
				if ft == 0:
					ft = 1
				obj.current_frame = int(i / ft) + frame_offset
				obj.update_sprite_frame()
				
				await obj.get_tree().process_frame

			if !playing:
				break
			
			#print("End of frame")

		playing = false
		obj.missed_attack = false
		obj.current_attack = null
		if obj.state == State.ATTACK:
			obj.set_state(State.IDLE)

	func set_sprite(new_spr_name : String, frames : int):
		sprite_name = new_spr_name
		sprite_frames = frames

	# Window operations
	func add_window(window: AttackWindow):
		windows.append(window)

	func set_window_value(window_num : int, param : AttackWindow.WindowParams, value):
		windows[window_num].set_param(param, value)
	
	# Hitbox operations
	func add_hitbox(hitbox: Hitbox):
		hitboxes.append(hitbox)

signal attack_parried(body : Character)

@export var show_name : String = "TestPlayer"
@export var character_name : String = "TestPlayer"
@export_range(1, 3, 1) var player_num : int = 1 # 1 for player 1, 2 for player 2 and 3 for computer

@export_group("Normal collision")
@export var collision_width : int = 23
@export var collision_height : int = 32
@export var collision_position : Vector2 = Vector2.ZERO

@export_group("Crouch collision")
@export var crouch_collision_width : int = 23
@export var crouch_collision_height : int = 32
@export var crouch_collision_position : Vector2 = Vector2.ZERO

# States
enum State {IDLE, WALK, RUN, ATTACK, PARRY, JUMP, FALL, HIT, DEAD, CROUCH}
var state : State = State.IDLE
var anim_ended : bool = false

# Animations
var sprites : Dictionary = {}

var idle_anim_speed : float = 0.1
var walk_anim_speed : float = 0.2
var run_anim_speed : float = 0.2
var parry_anim_speed : float = 0.2
var jump_anim_speed : float = 0.1
var fall_anim_speed : float = 0.1
var hit_anim_speed : float = 0.2
var dead_anim_speed : float = 0.2
var crouch_anim_speed : float = 0.2

var current_anim_speed : float = 0.2
var current_frame : float = 0

# Attacks
var weak_attack : Attack = Attack.new()
var strong_attack : Attack = Attack.new()
var weak_air_attack : Attack = Attack.new()
var strong_air_attack : Attack = Attack.new()
var special_attack : Attack = Attack.new()
var current_attack : Attack
var missed_attack = false

# Movement
var GROUND_SPEED : float = 300.0
var JUMP_VELOCITY : float = -400.0
var AIR_SPEED : float = 150.0
var direction : float = 0.0
var can_move : bool = true
var can_jump : bool = true
var friction = 0.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const MAX_HEALTH = 1000
var health = MAX_HEALTH

@onready var sprite_node : Sprite2D = $Sprite
@onready var collision_node : CollisionShape2D = $Collision

# Returns the complete action name for this player_num
func get_action(action_name : String) -> String:
	return "p" + str(player_num) + "-" + action_name

func set_sprite(spr_name : String) -> void:
	sprite_node.texture = sprites.get(spr_name)[0]
	sprite_node.hframes = sprites.get(spr_name)[1]

func set_state(new_state : State) -> void:
	# If the last state is different from the current state, reset the current_frame
	if state != new_state:
		current_frame = 0
	
	state = new_state

	if new_state != State.CROUCH:
		collision_node.position = collision_position
		collision_node.shape.size = Vector2(collision_width, collision_height)
	

	match new_state:
		State.WALK:
			current_anim_speed = walk_anim_speed
			set_sprite("Walk")
		State.RUN:
			current_anim_speed = run_anim_speed
			set_sprite("Run")
		State.ATTACK:
			pass
		State.PARRY:
			current_anim_speed = parry_anim_speed
			set_sprite("Parry")
		State.JUMP:
			current_anim_speed = jump_anim_speed
			set_sprite("Jump")
		State.FALL:
			current_anim_speed = fall_anim_speed
			set_sprite("Fall")
		State.HIT:
			current_anim_speed = hit_anim_speed
			set_sprite("Hit")
		State.DEAD:
			current_anim_speed = dead_anim_speed
			set_sprite("Death")
		State.CROUCH:
			current_anim_speed = crouch_anim_speed
			set_sprite("Crouch")
			collision_node.position = crouch_collision_position
			collision_node.shape.size = Vector2(crouch_collision_width, crouch_collision_height)
		_:
			current_anim_speed = idle_anim_speed
			set_sprite("Idle")
			state = State.IDLE

# Animates cycling animations; returns true if the animation just looped
func cycle_animate() -> bool:
	current_frame += current_anim_speed
	
	if current_frame >= sprite_node.hframes - 1:
		current_frame = 0

	update_sprite_frame()

	return current_frame > sprite_node.hframes - 1

# Animates non cycling animations; returns true if the animation has ended
func one_shot_animate() -> bool:
	current_frame += current_anim_speed
	if current_frame > sprite_node.hframes - 1:
		current_frame = sprite_node.hframes - 1
	
	update_sprite_frame()

	return current_frame >= sprite_node.hframes - 1
		
# Updates the frame of the sprite node of the character
func update_sprite_frame() -> void:
	# Set the frame as the last frame if current_frame is greater than the frames of the sprite
	if int(current_frame) > sprite_node.hframes - 1:
		current_frame = sprite_node.hframes - 1
	
	sprite_node.frame = int(current_frame)

func start_hitstop(time : float = 0.3) -> void:
	if current_attack != null:
		current_attack.playing = false
	set_state(State.HIT)
	$HitstopTimer.wait_time = time
	$HitstopTimer.start()

func take_damage(dmg : int) -> void:
	health -= dmg
	if health <= 0:
		health = 0
		set_state(State.DEAD)
	else:
		start_hitstop()

func set_attacks() -> void:
	weak_attack.set_sprite("WeakAttack", sprites["WeakAttack"][1])
	var weak_w1 = AttackWindow.new()
	weak_w1.set_param(AttackWindow.WindowParams.LENGTH, 3)
	weak_w1.set_param(AttackWindow.WindowParams.START_FRAME, 0)
	weak_w1.set_param(AttackWindow.WindowParams.NUM_FRAMES, 1)

	var weak_w2 = AttackWindow.new()
	weak_w2.set_param(AttackWindow.WindowParams.LENGTH, 6)
	weak_w2.set_param(AttackWindow.WindowParams.START_FRAME, 1)
	weak_w2.set_param(AttackWindow.WindowParams.NUM_FRAMES, 1)

	var weak_w3 = AttackWindow.new()
	weak_w3.set_param(AttackWindow.WindowParams.LENGTH, 10)
	weak_w3.set_param(AttackWindow.WindowParams.START_FRAME, 2)
	weak_w3.set_param(AttackWindow.WindowParams.NUM_FRAMES, 1)

	weak_attack.add_window(weak_w1)
	weak_attack.add_window(weak_w2)
	weak_attack.add_window(weak_w3)

	var weak_h1 = Hitbox.new(self)
	
	weak_h1.length = 6
	weak_h1.window_number = 1
	weak_h1.width = 15
	weak_h1.height = 25
	weak_h1.position_x = 20
	weak_h1.position_y = -7
	weak_attack.add_hitbox(weak_h1)
	

	strong_attack.set_sprite("StrongAttack", sprites["StrongAttack"][1])
	var strong_w1 = AttackWindow.new()
	strong_w1.set_param(AttackWindow.WindowParams.LENGTH, 6)
	strong_w1.set_param(AttackWindow.WindowParams.START_FRAME, 0)
	strong_w1.set_param(AttackWindow.WindowParams.NUM_FRAMES, 2)

	var strong_w2 = AttackWindow.new()
	strong_w2.set_param(AttackWindow.WindowParams.LENGTH, 10)
	strong_w2.set_param(AttackWindow.WindowParams.START_FRAME, 2)
	strong_w2.set_param(AttackWindow.WindowParams.NUM_FRAMES, 3)
	strong_w2.set_param(AttackWindow.WindowParams.VELOCITY_X, 200)

	var strong_w3 = AttackWindow.new()
	strong_w3.set_param(AttackWindow.WindowParams.LENGTH, 10)
	strong_w3.set_param(AttackWindow.WindowParams.START_FRAME, 5)
	strong_w3.set_param(AttackWindow.WindowParams.NUM_FRAMES, 3)
	strong_w3.set_param(AttackWindow.WindowParams.HAS_WHIFFLAG, true)

	strong_attack.add_window(strong_w1)
	strong_attack.add_window(strong_w2)
	strong_attack.add_window(strong_w3)

	var strong_h1 = Hitbox.new(self)
	strong_h1.length = 6
	strong_h1.window_number = 1
	strong_h1.width = 40
	strong_h1.height = 20
	strong_h1.position_x = 10
	strong_h1.position_y = 5
	strong_attack.add_hitbox(strong_h1)


	special_attack.set_sprite("SpecialAttack", sprites["SpecialAttack"][1])

	var special_w1 = AttackWindow.new()
	special_w1.set_param(AttackWindow.WindowParams.LENGTH, 3)
	special_w1.set_param(AttackWindow.WindowParams.START_FRAME, 0)
	special_w1.set_param(AttackWindow.WindowParams.NUM_FRAMES, 2)

	var special_w2 = AttackWindow.new()
	special_w2.set_param(AttackWindow.WindowParams.LENGTH, 6)
	special_w2.set_param(AttackWindow.WindowParams.START_FRAME, 2)
	special_w2.set_param(AttackWindow.WindowParams.NUM_FRAMES, 1)

	var special_w3 = AttackWindow.new()
	special_w3.set_param(AttackWindow.WindowParams.LENGTH, 10)
	special_w3.set_param(AttackWindow.WindowParams.START_FRAME, 3)
	special_w3.set_param(AttackWindow.WindowParams.NUM_FRAMES, 2)

	special_attack.add_window(special_w1)
	special_attack.add_window(special_w2)
	special_attack.add_window(special_w3)

	var special_h1 = Hitbox.new(self)
	special_h1.length = 60
	special_h1.window_number = 1
	special_h1.type = 1
	special_h1.width = 15
	special_h1.height = 25
	special_h1.position_x = 20
	special_h1.position_y = -7
	special_h1.velocity_x = 200
	special_h1.velocity_y = 0
	special_h1.sprite_name = "nspecial_proj"
	special_attack.add_hitbox(special_h1)


	weak_air_attack.set_sprite("AirWeakAttack", sprites["AirWeakAttack"][1])
	var weak_air_w1 = AttackWindow.new()
	weak_air_w1.set_param(AttackWindow.WindowParams.LENGTH, 3)
	weak_air_w1.set_param(AttackWindow.WindowParams.START_FRAME, 0)
	weak_air_w1.set_param(AttackWindow.WindowParams.NUM_FRAMES, 1)

	var weak_air_w2 = AttackWindow.new()
	weak_air_w2.set_param(AttackWindow.WindowParams.LENGTH, 6)
	weak_air_w2.set_param(AttackWindow.WindowParams.START_FRAME, 1)
	weak_air_w2.set_param(AttackWindow.WindowParams.NUM_FRAMES, 2)

	var weak_air_w3 = AttackWindow.new()
	weak_air_w3.set_param(AttackWindow.WindowParams.LENGTH, 10)
	weak_air_w3.set_param(AttackWindow.WindowParams.START_FRAME, 3)
	weak_air_w3.set_param(AttackWindow.WindowParams.NUM_FRAMES, 1)

	weak_air_attack.add_window(weak_air_w1)
	weak_air_attack.add_window(weak_air_w2)
	weak_air_attack.add_window(weak_air_w3)

	var weak_air_h1 = Hitbox.new(self)
	
	weak_air_h1.length = 6
	weak_air_h1.window_number = 1
	weak_air_h1.width = 24.5
	weak_air_h1.height = 35
	weak_air_h1.position_x = 35
	weak_air_h1.position_y = 3
	weak_air_attack.add_hitbox(weak_air_h1)


	strong_air_attack.set_sprite("AirStrongAttack", sprites["AirStrongAttack"][1])
	var strong_air_w1 = AttackWindow.new()
	strong_air_w1.set_param(AttackWindow.WindowParams.LENGTH, 6)
	strong_air_w1.set_param(AttackWindow.WindowParams.START_FRAME, 0)
	strong_air_w1.set_param(AttackWindow.WindowParams.NUM_FRAMES, 2)

	var strong_air_w2 = AttackWindow.new()
	strong_air_w2.set_param(AttackWindow.WindowParams.LENGTH, 10)
	strong_air_w2.set_param(AttackWindow.WindowParams.START_FRAME, 2)
	strong_air_w2.set_param(AttackWindow.WindowParams.NUM_FRAMES, 3)
	strong_air_w2.set_param(AttackWindow.WindowParams.VELOCITY_X, 200)
	strong_air_w2.set_param(AttackWindow.WindowParams.VELOCITY_Y, -40)

	var strong_air_w3 = AttackWindow.new()
	strong_air_w3.set_param(AttackWindow.WindowParams.LENGTH, 10)
	strong_air_w3.set_param(AttackWindow.WindowParams.START_FRAME, 5)
	strong_air_w3.set_param(AttackWindow.WindowParams.NUM_FRAMES, 3)
	strong_air_w3.set_param(AttackWindow.WindowParams.HAS_WHIFFLAG, true)

	strong_air_attack.add_window(strong_air_w1)
	strong_air_attack.add_window(strong_air_w2)
	strong_air_attack.add_window(strong_air_w3)

	var strong_air_h1 = Hitbox.new(self)
	strong_air_h1.length = 6
	strong_air_h1.window_number = 1
	strong_air_h1.width = 40
	strong_air_h1.height = 20
	strong_air_h1.position_x = 10
	strong_air_h1.position_y = 5
	strong_air_attack.add_hitbox(strong_air_h1)

func _ready():
	# Setting the collision size for the character
	var shape = RectangleShape2D.new()
	shape.size = Vector2(collision_width, collision_height)
	collision_node.shape = shape
	collision_node.position = collision_position
	
	var dir = DirAccess.open("res://Assets/Sprites/Characters/" + character_name)
	if dir:
		# Cycling trough all the files in the directory
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and !file_name.ends_with(".import"):
				#print("Found file: " + file_name)

				# Adding the sprite information to the sprites dict
				var spr_name = file_name.split(".")[0]
				var spr_frames = int(spr_name.split("__")[1])
				var sprite = load("res://Assets/Sprites/Characters/" + character_name + "/" + file_name)

				sprites[spr_name.split("__")[0]] = [sprite, spr_frames]

			file_name = dir.get_next()
	else:
		print("No folder with the name " + character_name)

	set_state(State.IDLE)

	set_attacks()

func _physics_process(delta : float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if can_jump:
		# Handle jump.
		if Input.is_action_just_pressed(get_action("jump")) and is_on_floor():
			velocity.y = JUMP_VELOCITY
	
	
	direction = Input.get_axis(get_action("left"), get_action("right"))

	if direction:
		direction = direction / abs(direction) # Convert direction to -1 or 1

		if can_move:
			if not is_on_floor():
				velocity.x = direction * AIR_SPEED
			if is_on_floor():
				velocity.x = direction * GROUND_SPEED
		else:
			velocity.x = lerp(velocity.x, 0.0, friction)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		#velocity.x = move_toward(velocity.x, 0, GROUND_SPEED)

	# Changing the state
	can_move = state != State.ATTACK and state != State.PARRY and state != State.HIT and state != State.DEAD
	can_jump = state != State.ATTACK and state != State.PARRY and state != State.HIT and state != State.DEAD
	if can_move:
		if is_on_floor():
			if direction:
				set_state(State.RUN)
			elif Input.is_action_pressed(get_action("crouch")):
				set_state(State.CROUCH)
			elif Input.is_action_just_pressed(get_action("parry")):
				set_state(State.PARRY)
			else:
				set_state(State.IDLE)
		elif velocity.y < 0:
			set_state(State.JUMP)
		else:
			set_state(State.FALL)

		var weak_pressed = Input.is_action_just_pressed(get_action("weak"))
		var strong_pressed = Input.is_action_just_pressed(get_action("strong"))
		var special_pressed = Input.is_action_just_pressed(get_action("special"))

		if (weak_pressed or strong_pressed or special_pressed) and (state == State.CROUCH or state == State.IDLE or not is_on_floor()):
			set_state(State.ATTACK)

			if weak_pressed:
				if is_on_floor():
					weak_attack.play(self)
				else:
					weak_air_attack.play(self)
			elif strong_pressed:
				if is_on_floor():
					strong_attack.play(self)
				else:
					strong_air_attack.play(self)
			elif special_pressed:
				if is_on_floor():
					special_attack.play(self)
				else:
					set_state(State.IDLE)
	elif state == State.PARRY:
		if anim_ended:
			set_state(State.IDLE)
	
	# How to animate each state
	match state:
		State.IDLE, State.WALK, State.RUN, State.FALL:
			anim_ended = cycle_animate()
		State.JUMP, State.HIT, State.DEAD, State.CROUCH, State.PARRY:
			anim_ended = one_shot_animate()
	
	move_and_slide()


func _on_attack_landed(body, area : Hitbox) -> void:
	# Ignore attack of attack comes from itself or if the body is not a character
	if body == self or not body is Character:
		return
	
	if body.state == State.PARRY:
		body.attack_parried.emit(body)
		start_hitstop(1)
	else:
		body.take_damage(area.damage)


func _on_hitstop_timer_timeout() -> void:
	# Go back to normal if it isn't dead
	if state == State.HIT:
		set_state(State.IDLE)

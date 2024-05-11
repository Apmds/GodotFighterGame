class_name Level extends Node2D

@onready var camera : GameCamera = $Camera
@onready var player1_hp_bar : ColorRect = $HUD/Player1/HPBar
@onready var player1_showname : Label = $HUD/Player1/Name
@onready var player2_hp_bar : ColorRect = $HUD/Player2/HPBar
@onready var player2_showname : Label = $HUD/Player2/Name
var player1 : Character
var player2 : Character
var stage_name : String = "TestStage"
var ground_level : float = 280

var sprites : Dictionary = {}

func _init():
	# Loads the sprites
	var dir = DirAccess.open("res://Assets/Sprites/Stages/" + stage_name)
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
				var sprite = load("res://Assets/Sprites/Stages/" + stage_name + "/" + file_name)

				sprites[spr_name.split("__")[0]] = [sprite, spr_frames]

			file_name = dir.get_next()
	else:
		push_error("No folder with the name " + name)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	var players = $Players.get_children()
	if len(players) != 2:
		assert(false, "There are not 2 players present on stage!")
	
	for player in players:
		if player.player_num == 1 and player1 == null:
			player1 = player
		if player.player_num == 2 and player2 == null:
			player2 = player
	
	if player1 == null or player2 == null:
		assert(false, "There isn't a player 1 and a player 2 defined!")
	
	player1.connect("attack_parried", _on_attack_parried)
	player2.connect("attack_parried", _on_attack_parried)
	
	# Basic setup
	$Ground.position.y = ground_level
	if get_node_or_null("Background") != null and sprites.get("Background") != null:
		$Background/StageBackground.texture = sprites.get("Background")[0]
		$Background/StageBackground.hframes = sprites.get("Background")[1]
	player1_showname.text = player1.show_name
	player2_showname.text = player2.show_name

#var i = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	player1.get_node("Sprite").flip_h = player1.position.x > player2.position.x
	player2.get_node("Sprite").flip_h = not (player1.position.x > player2.position.x)
	
	#i += 1
	#if i % 60 == 0:
	#	Input.action_press("p1-strong")
	#	Input.action_release("p1-strong")
	
	player1_hp_bar.size.x = 240 * (float(player1.health)/float(player1.MAX_HEALTH))
	player2_hp_bar.size.x = 240 * (float(player2.health)/float(player2.MAX_HEALTH))

func _on_attack_parried(_body : Character):
	camera.shake()
	#camera.zoom_into(body)

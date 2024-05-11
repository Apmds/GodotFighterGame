extends Node2D

@onready var camera : GameCamera = $Camera
@onready var player1_hp_bar : ColorRect = $HUD/Player1/HPBar
@onready var player1_showname : Label = $HUD/Player1/Name
@onready var player2_hp_bar : ColorRect = $HUD/Player2/HPBar
@onready var player2_showname : Label = $HUD/Player2/Name
var player1 : Character
var player2 : Character

# Called when the node enters the scene tree for the first time.
func _ready():
	var players = $Players.get_children()
	player1 = players[0]
	player1.connect("attack_parried", _on_attack_parried)

	player2 = players[1]
	player2.connect("attack_parried", _on_attack_parried)
	
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

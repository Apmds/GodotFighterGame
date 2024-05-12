class_name Brawlina extends Character


func set_attacks():
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
	super()


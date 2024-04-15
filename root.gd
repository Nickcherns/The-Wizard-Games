extends Node2D

@export var w_key: Texture2D
@export var a_key: Texture2D
@export var s_key: Texture2D
@export var d_key: Texture2D
@export var w_key_success: Texture2D
@export var a_key_success: Texture2D
@export var s_key_success: Texture2D
@export var d_key_success: Texture2D
@export var w_key_fail: Texture2D
@export var a_key_fail: Texture2D
@export var s_key_fail: Texture2D
@export var d_key_fail: Texture2D
@export var Enemy: PackedScene
@onready var h_box = $mainPanel/userPanel/HBoxContainer
@onready var user_key1 = $mainPanel/userPanel/HBoxContainer/user_key1
@onready var user_key2 = $mainPanel/userPanel/HBoxContainer/user_key2
@onready var user_key3 = $mainPanel/userPanel/HBoxContainer/user_key3
@onready var user_key4 = $mainPanel/userPanel/HBoxContainer/user_key4
@onready var rand_key_res1 = preload("res://resources/key_set1.tres")
@onready var rand_key_res2 = preload("res://resources/key_set2.tres")
@onready var rand_key_res3 = preload("res://resources/key_set3.tres")
@onready var rand_key_res4 = preload("res://resources/key_set4.tres")
@onready var base_key_set = $"mainPanel/Key Set"
@onready var main_menu: PackedScene = load("res://main_menu.tscn")
@onready var player_config: Resource = preload("res://resources/player.tres")
@onready var enemy_config: Resource = preload("res://resources/enemy.tres")
var user_input_dict: Dictionary
var sprite_array: Array[Sprite2D]
var rand_key1: String
var rand_key2: String
var rand_key3: String
var rand_key4: String
var rand_key_array: Array[String] = [rand_key1, rand_key2, rand_key3, rand_key4]
var score: int

signal correct_input
signal failed_input
signal game_over_stop
signal game_over_stop2

func _ready():
	base_key_set.timer_start.connect(start_timer)
	$gameOverPanel.visible = false
	$Player.player_attacked.connect(player_take_damage)
	$GameTimer.start()
	

func _process(_delta):
	if player_config.health < 100:
		$"Player Health".text = "Player Health: %02d" % player_config.health
	else: 
		$"Player Health".text = "Player Health: %03d" % player_config.health
	if enemy_config.health < 100:
		$"Enemy Health".text = "Enemy Health: %02d" %  enemy_config.health
	else:
		$"Enemy Health".text = "Enemy Health: %03d" %  enemy_config.health
		
	$mainPanel/Score.text = "Score: %03d" % score
	if player_config.health <= 0:
		$CrowdNoise.play()
		game_over()
	if enemy_config.health <= 0:
		$CrowdNoise.play()
		$EnemyDefeat.play()
		enemy_death()
	$mainPanel/TimeLeft/Countdown.text = "%01d: %02d" % time_left()
	if $gameOverPanel.visible == true:
		emit_signal("game_over_stop2")
		if Input.is_action_just_pressed("W"):
			pass
		elif Input.is_action_just_pressed("A"):
			pass
		elif Input.is_action_just_pressed("S"):
			pass
		elif Input.is_action_just_pressed("D"):
			pass
		elif Input.is_action_just_pressed("backspace"):
			pass
	else: 
		if Input.is_action_just_pressed("W"):
			$KeyClick.play()
			create_sprite2d(w_key, "w")
		elif Input.is_action_just_pressed("A"):
			$KeyClick.play()
			create_sprite2d(a_key, "a")
		elif Input.is_action_just_pressed("S"):
			$KeyClick.play()
			create_sprite2d(s_key, "s")
		elif Input.is_action_just_pressed("D"):
			$KeyClick.play()
			create_sprite2d(d_key, "d")
	
func start_timer():
	$RandKeyChangeTimer.start()

func create_sprite2d(texture: Texture2D, user_key: String) -> void:
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.scale = Vector2(2, 2)
	sprite_array.append(sprite)
	if sprite_array.size() == 1:
		sprite_array[-1].name = "user_key1"
		add_user_input(user_key1, user_key)
		user_key1.add_child(sprite_array[-1])
	if sprite_array.size() == 2:
		sprite_array[-1].name = "user_key2"
		add_user_input(user_key2, user_key)
		user_key2.add_child(sprite_array[-1])
	if sprite_array.size() == 3:
		sprite_array[-1].name = "user_key3"
		add_user_input(user_key3, user_key)
		user_key3.add_child(sprite_array[-1])
	if sprite_array.size() == 4:
		sprite_array[-1].name = "user_key4"
		add_user_input(user_key4, user_key)
		user_key4.add_child(sprite_array[-1])
	if sprite_array.size() >= 4:
		$mainPanel/userPanel/HBoxContainer/Timer.start()
		set_rand_keys()
		key_user_check()

func game_over():
	emit_signal("game_over_stop")
	$GameTimer.stop()
	$RandKeyChangeTimer.stop()
	$gameOverPanel.visible = true
	$gameOverPanel/FinalScore.text = "Score: %03d" % score

func clear_children(node: Node2D):
	$mainPanel/sequenceComplete.visible = false
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func add_user_input(key, user_input):
	if user_input == "w":
		user_input_dict[key] = "w"
	if user_input == "s":
		user_input_dict[key] = "s"
	if user_input == "d":
		user_input_dict[key] = "d"
	if user_input == "a":
		user_input_dict[key] = "a"

func _on_timer_timeout():
	$mainPanel/userPanel/HBoxContainer/Timer.stop()
	sprite_array.clear()
	clear_children(user_key1)
	clear_children(user_key2)
	clear_children(user_key3)
	clear_children(user_key4)
	
func key_user_check():
	var correct_input_key1: bool
	var correct_input_key2: bool
	var correct_input_key3: bool
	var correct_input_key4: bool
	#USER KEY 1
	if rand_key_array[0] == user_input_dict[user_key1]:
		correct_input_key1 = true
		var input: Sprite2D = sprite_array[0]
		if user_input_dict[user_key1] == "w":
			input.texture = w_key_success
		if user_input_dict[user_key1] == "a":
			input.texture = a_key_success
		if user_input_dict[user_key1] == "s":
			input.texture = s_key_success
		if user_input_dict[user_key1] == "d":
			input.texture = d_key_success
	else: 
		correct_input_key1 = false
		var input: Sprite2D = sprite_array[0]
		if user_input_dict[user_key1] == "w":
			input.texture = w_key_fail
		if user_input_dict[user_key1] == "a":
			input.texture = a_key_fail
		if user_input_dict[user_key1] == "s":
			input.texture = s_key_fail
		if user_input_dict[user_key1] == "d":
			input.texture = d_key_fail
	# USER KEY 2
	if rand_key_array[1] == user_input_dict[user_key2]:
		correct_input_key2 = true
		var input: Sprite2D = sprite_array[1]
		if user_input_dict[user_key2] == "w":
			input.texture = w_key_success
		if user_input_dict[user_key2] == "a":
			input.texture = a_key_success
		if user_input_dict[user_key2] == "s":
			input.texture = s_key_success
		if user_input_dict[user_key2] == "d":
			input.texture = d_key_success
	else: 
		correct_input_key2 = false
		var input: Sprite2D = sprite_array[1]
		if user_input_dict[user_key2] == "w":
			input.texture = w_key_fail
		if user_input_dict[user_key2] == "a":
			input.texture = a_key_fail
		if user_input_dict[user_key2] == "s":
			input.texture = s_key_fail
		if user_input_dict[user_key2] == "d":
			input.texture = d_key_fail
	#USER KEY 3
	if rand_key_array[2] == user_input_dict[user_key3]:
		correct_input_key3 = true
		var input: Sprite2D = sprite_array[2]
		if user_input_dict[user_key3] == "w":
			input.texture = w_key_success
		if user_input_dict[user_key3] == "a":
			input.texture = a_key_success
		if user_input_dict[user_key3] == "s":
			input.texture = s_key_success
		if user_input_dict[user_key3] == "d":
			input.texture = d_key_success
	else: 
		correct_input_key3 = false
		var input: Sprite2D = sprite_array[2]
		if user_input_dict[user_key3] == "w":
			input.texture = w_key_fail
		if user_input_dict[user_key3] == "a":
			input.texture = a_key_fail
		if user_input_dict[user_key3] == "s":
			input.texture = s_key_fail
		if user_input_dict[user_key3] == "d":
			input.texture = d_key_fail
	#USER KEY 4
	if rand_key_array[3] == user_input_dict[user_key4]:
		correct_input_key4 = true
		var input: Sprite2D = sprite_array[3]
		if user_input_dict[user_key4] == "w":
			input.texture = w_key_success
		if user_input_dict[user_key4] == "a":
			input.texture = a_key_success
		if user_input_dict[user_key4] == "s":
			input.texture = s_key_success
		if user_input_dict[user_key4] == "d":
			input.texture = d_key_success
	else: 
		correct_input_key4 = false
		var input: Sprite2D = sprite_array[3]
		if user_input_dict[user_key4] == "w":
			input.texture = w_key_fail
		if user_input_dict[user_key4] == "a":
			input.texture = a_key_fail
		if user_input_dict[user_key4] == "s":
			input.texture = s_key_fail
		if user_input_dict[user_key4] == "d":
			input.texture = d_key_fail
	
	if correct_input_key1 == true and correct_input_key2 == true and correct_input_key3 == true and correct_input_key4 == true: 
		$mainPanel/sequenceComplete.visible = true
		emit_signal("correct_input")
	else:
		emit_signal("failed_input")
			
func set_rand_keys():
	rand_key_array.clear()
	rand_key1 = rand_key_res1.rand_key
	rand_key2 = rand_key_res2.rand_key
	rand_key3 = rand_key_res3.rand_key
	rand_key4 = rand_key_res4.rand_key
	rand_key_array = [rand_key1, rand_key2, rand_key3, rand_key4]

func time_left():
	var timer_time_left = $GameTimer.time_left
	var minutes = floor(timer_time_left / 60)
	var sec = int(timer_time_left) % 60
	return [minutes, sec]

func _on_rand_key_change_timer_timeout():
	set_rand_keys()

func player_take_damage():
	$Background.play("default")
	$CrowdNoise.play()
	score -= 50
	
func enemy_take_damage():
	$Background.play("default")
	score += 25

func _on_quit_pressed():
	get_tree().change_scene_to_packed(main_menu)
	
func _on_restart_pressed():
	get_tree().reload_current_scene()
	player_config.health = 100
	enemy_config.health = 100
		
func enemy_death():
	$Background.play("default")
	score += 75
	var root_children = $".".get_children()
	var enemy_node: Node2D
	for i in len(root_children):
		if root_children[i].is_in_group("enemy"):
			enemy_node = root_children[i]
	enemy_node.queue_free()
	var new_enemy = Enemy.instantiate()
	$".".add_child(new_enemy)
	new_enemy.add_to_group("enemy")
	new_enemy.enemy_attacked.connect(enemy_take_damage)
	new_enemy.global_transform = $EnemySpawn.global_transform


func _on_game_timer_timeout():
	game_over()


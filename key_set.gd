extends Node2D

@onready var w: Sprite2D = $W
@onready var a: Sprite2D = $A
@onready var s: Sprite2D = $S
@onready var d: Sprite2D = $D
@onready var timer: Timer = $Timer
@onready var key_set: Array[Sprite2D] = [w, a, s, d]
@onready var key_set_string: Array[String] = ["w", "a", "s", "d"]
@onready var rand_key: Sprite2D
@onready var key_set_res: Resource
var prev_key: Sprite2D
var KEY_SET_FRAME_DEFAULT: int = 0
@onready var root_node = $"../.."

signal timer_start
# Called when the node enters the scene tree for the first time.
func _ready():
	#$Timer.start()
	emit_signal("timer_start")
	if $".".name == "Key Set":
		key_set_res = preload("res://resources/key_set1.tres")
	elif $".".name == "Key Set2":
		key_set_res = preload("res://resources/key_set2.tres")
	elif $".".name == "Key Set3":
		key_set_res = preload("res://resources/key_set3.tres")
	elif $".".name == "Key Set4":
		key_set_res = preload("res://resources/key_set4.tres")
	rand_key = return_random_key()
	set_random_keys()
	root_node.correct_input.connect(handle_correct_input)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in key_set.size():
		if rand_key != key_set[i]:
			key_set[i].frame = KEY_SET_FRAME_DEFAULT
			

func return_random_key() -> Sprite2D:
	return key_set.pick_random()
	
	
func handle_correct_input():
	#$Timer.start()
	set_random_keys()

func set_random_keys():
	prev_key = rand_key
	prev_key.frame = KEY_SET_FRAME_DEFAULT
	rand_key = return_random_key()
	while rand_key == prev_key:
		rand_key = return_random_key()
	if rand_key == w:
		key_set_res.rand_key = ("w")
	if rand_key == a:
		key_set_res.rand_key = ("a")
	if rand_key == s:
		key_set_res.rand_key = ("s")
	if rand_key == d:
		key_set_res.rand_key = ("d")
	key_set_res.print_rand_key()
	#if rand_key == prev_key:
		#_on_timer_timeout()
	rand_key.frame = 1

func _on_timer_timeout():
	pass
	

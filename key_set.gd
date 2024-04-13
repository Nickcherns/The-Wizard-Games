extends Node2D

@onready var w: Sprite2D = $W
@onready var a: Sprite2D = $A
@onready var s: Sprite2D = $S
@onready var d: Sprite2D = $D
@onready var timer: Timer = $Timer
@onready var key_set: Array[Sprite2D] = [w, a, s, d]
@onready var rand_key: Sprite2D
var prev_key: Sprite2D
var KEY_SET_FRAME_DEFAULT: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	rand_key = return_random_key()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in key_set.size():
		if rand_key != key_set[i]:
			key_set[i].frame = KEY_SET_FRAME_DEFAULT

func return_random_key() -> Sprite2D:
	return key_set.pick_random()
	
func _on_timer_timeout():
	prev_key = rand_key
	prev_key.frame = KEY_SET_FRAME_DEFAULT
	rand_key = return_random_key()
	if rand_key == prev_key:
		_on_timer_timeout()
	rand_key.frame = 1

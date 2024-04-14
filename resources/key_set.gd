extends Resource

class_name Key_Set


var rand_key: String
var user_key: String
@export var key_set_num: int

func print_rand_key() -> void:
	print("Key Set #", key_set_num)
	print(rand_key)
	print("-------------")

func set_rand_key(key_set_key) -> void:
	rand_key = key_set_key
	
func set_user_key(user_input):
	user_key = user_input

extends Resource

class_name Participant

@export var texture: Texture2D
@export var attack_texture: Texture2D
var health: int = 100

func take_damage(dmg) -> void:
	health -= dmg

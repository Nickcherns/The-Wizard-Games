extends Node2D

@onready var config: Resource = preload("res://resources/player.tres")
@export var Attack: PackedScene
@export var damage_intake: int

signal player_attacked

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	$".".get_parent().correct_input.connect(summon)
	$".".get_parent().failed_input.connect(summon_fail)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func summon() -> void:
	$playerAttack.play()
	var attack = Attack.instantiate()
	attack.set_sprite_texture(config.attack_texture)
	$".".add_child(attack) 
	$AnimatedSprite2D.play("attack")
	attack.add_to_group("attack")
	attack.global_transform = $Marker2D.global_transform
	
func summon_fail() -> void:
	$AnimatedSprite2D.play("fail")
	$PlayerFail.play()
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy_attack"):
		area.queue_free()
		config.take_damage(damage_intake)
		emit_signal("player_attacked")

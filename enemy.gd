extends Node2D

@onready var config: Resource = preload("res://resources/enemy.tres")
@export var Attack: PackedScene
@export var damage_intake: int

signal enemy_attacked

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	$".".get_parent().game_over_stop.connect(stop_timer)
	$".".get_parent().game_over_stop2.connect(stop_timer)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if config.health <= 0:
		config.health = 100


func _on_timer_timeout():
	$enemyAttack.play()
	$AnimatedSprite2D.play("default")
	
	var attack = Attack.instantiate()
	attack.set_sprite_texture(config.attack_texture)
	$".".add_child(attack)
	attack.add_to_group("enemy_attack")
	attack.global_transform = $Marker2D.global_transform

func _on_area_2d_area_entered(area):
	if area.is_in_group("attack"):
		$CrowdNoise.play()
		area.queue_free()
		config.take_damage(damage_intake)
		emit_signal("enemy_attacked")

func _on_tree_entered():
	var tween = create_tween()
	tween.tween_property($".", "position:x", -280.0, 0.8).as_relative()

func stop_timer():
	$Timer.stop()

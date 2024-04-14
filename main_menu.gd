extends Control

@onready var game_scene: PackedScene = preload("res://root.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	$crowd.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_how_to_play_pressed():
	$keyClick.play()
	$"How To Play".visible = true
	


func _on_play_pressed():
	$keyClick.play()
	$crowd.play()
	get_tree().change_scene_to_packed(game_scene)


func _on_quit_pressed():
	$keyClick.play()
	get_tree().quit()
	

func _on_close_pressed():
	$keyClick.play()
	$"How To Play".visible = false
	

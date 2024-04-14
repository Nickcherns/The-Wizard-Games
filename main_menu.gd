extends Control

@onready var game_scene: PackedScene 

func _ready():
	$AnimatedSprite2D.play("default")
	game_scene = load("res://root.tscn")
	$TheWizardGames.play()
func _process(_delta):
	pass

func _on_how_to_play_pressed():
	$keyClick.play()
	$"How To Play".visible = true
	
func _on_play_pressed():
	$keyClick.play()
	$Story.visible = true

func _on_close_pressed():
	$keyClick.play()
	$"How To Play".visible = false
	
func _on_continue_pressed():
	$keyClick.play()
	$crowd.play()
	get_tree().change_scene_to_packed(game_scene)

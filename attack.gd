extends Area2D

var speed = 200
var degrees_per_second = 180.0
@onready var parent_node = self.get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if $".".is_in_group("attack"):
		$Sprite2D.rotate(delta * deg_to_rad(degrees_per_second))
		position += (transform.x * speed * delta)
	elif $".".is_in_group("enemy_attack"):
		$Sprite2D.rotate(delta * deg_to_rad(degrees_per_second))
		position += -(transform.x * speed * delta)
		
	

	
		
func set_sprite_texture(texture):
	$Sprite2D.texture = texture


func _on_area_entered(area):
	if area.is_in_group("attack") or area.is_in_group("enemy_attack"):
		$".".queue_free()

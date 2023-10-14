extends StaticBody2D

@export var Data = {}
@export var type = ""

func _ready():
	var typeA = get_parent().name
	var typeB = get_parent().name
	if typeA == "Turret":
		typeB = name+"/"+name
	type = name
	var size = animated_sprite(typeA+"/"+typeB)
	scale = Vector2(100 / size.x, 100 / size.y)
	resize_id(size)
	resize_area(size)
	resize_outline(size)
	resize_select(size)
	if get_parent().name == "Castle":
		castle_customs(size)
	name = str(get_instance_id())
	
func castle_customs(size):
	var upscale = 2.5
	scale = Vector2(100 * upscale / size.x, 100 * upscale / size.y)
	$Outline.scale *= 2 / upscale
	$Outline.width *= 1- 2 / upscale
	$Outline.hide()

func animated_sprite(filename):
	var sprite_path = "res://Scenes/Building/"+filename+".tres"
	if !FileAccess.file_exists(sprite_path):
		return
	$Sprite.sprite_frames = load(sprite_path)
	var texture = $Sprite.sprite_frames.get_frame_texture("default", 0)
	var size = texture.get_size()
	return size

func resize_id(size):
	var id = get_node_or_null("ID")
	if id:
		id.text = str(get_instance_id())
		id.size.x = size.x
		id.position.x = -size.x/2

func resize_area(size):
	$Area2D.scale.x = size.x*0.8
	$Area2D.scale.y = size.y*0.7
	
func resize_select(size):
	$Select.scale.x = size.x
	$Select.scale.y = size.y*0.7
	
func rotate_area():
	$Area2D.rotation = deg_to_rad(45)
	$CollisionShape2D.rotation = deg_to_rad(45)

func resize_outline(size):	
	for i in $Outline.points.size():
		$Outline.points[i] *= size/2

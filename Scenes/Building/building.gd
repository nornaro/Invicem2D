extends StaticBody2D



@export var Data = {}
@export var type = ""

func _ready():
	var typeA = get_parent().name
	var typeB = get_parent().name
	if typeA == "Turret":
		typeB = "Type/"+name+"/"+name
	type = name
	var size = animated_sprite(typeA+"/"+typeB)
	$Sprite.scale = Vector2(100,100)/size
	if get_parent().name == "Castle":
		$Sprite.scale *= 2.5
		size *= 2.5
	if typeA != "Turret":
		size /= 5
	size /= 2
	resize_id(size)
	resize_area(size)
	resize_outline(size)
	resize_select(size)
	name = str(get_instance_id())


func animated_sprite(filename):
	var sprite_path = "res://Scenes/Building/" + filename + ".tres"
	if !FileAccess.file_exists(sprite_path):
		return
	$Sprite.set_meta("sprite_path",sprite_path)
	$Sprite.set_random()
	var size = $Sprite.sprite_frames.get_frame_texture(Global.style,$Sprite.frame).get_size()
	return size

func resize_id(size):
	var id = get_node_or_null("ID")
	if id:
		id.text = str(get_instance_id())
		id.size.x = size.x
		id.position.x = -size.x/2

func resize_area(size):
	$Area/Shape.shape = RectangleShape2D.new()
	$Area/Shape.shape.set_size(Vector2(int(size.x*0.8),int(size.y*0.7)))


func resize_select(size):
	for child in $Select.get_children():
		child.points = [
			Vector2(size.x * -0.5,size.y * -0.5),
			Vector2(size.x *  0.5,size.y * -0.5),
			Vector2(size.x *  0.5,size.y *  0.5),
			Vector2(size.x * -0.5,size.y *  0.5),
			Vector2(size.x * -0.5,size.y * -0.5)
		]
	
func rotate_area():
	$Area.rotation = deg_to_rad(45)
	$CollisionShape2D.rotation = deg_to_rad(45)

func resize_outline(size):
	$Outline.points = [
		Vector2(size.x * -0.5,size.y * -0.5),
		Vector2(size.x *  0.5,size.y * -0.5),
		Vector2(size.x *  0.5,size.y *  0.5),
		Vector2(size.x * -0.5,size.y *  0.5),
		Vector2(size.x * -0.5,size.y * -0.5)
	]

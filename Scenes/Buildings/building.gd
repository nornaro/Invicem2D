extends StaticBody2D

@export var Data:Dictionary = {}
@export var type:String = ""

func _ready() -> void:
	var typeA:String = get_parent().name
	var typeB:String = get_parent().name
	if typeA == "Turret":
		typeB = "Type/"+name+"/"+name
	type = name
	var size:Vector2 = animated_sprite(typeA+"/"+typeB)
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

func animated_sprite(filename:String) -> Vector2:
	var sprite_path:String = "res://Scenes/Buildings/" + filename + ".tres"
	if !Global.RL.file_exists(sprite_path):
		return Vector2.ZERO
	$Sprite.set_meta("sprite_path",sprite_path)
	$Sprite.set_random()
	var size:Vector2 = $Sprite.sprite_frames.get_frame_texture(Global.style,$Sprite.frame).get_size()
	return size

func resize_id(size:Vector2) -> void:
	var id:Node = get_node_or_null("ID")
	if id:
		id.text = str(get_instance_id())
		id.size.x = size.x
		id.position.x = -size.x/2

func resize_area(size:Vector2) -> void:
	$Area/Shape.shape = RectangleShape2D.new()
	$Area/Shape.shape.set_size(Vector2(int(size.x*0.8),int(size.y*0.7)))


func resize_select(size:Vector2) -> void:
	for child in $Select.get_children():
		child.points = [
			Vector2(size.x * -0.5,size.y * -0.5),
			Vector2(size.x *  0.5,size.y * -0.5),
			Vector2(size.x *  0.5,size.y *  0.5),
			Vector2(size.x * -0.5,size.y *  0.5),
			Vector2(size.x * -0.5,size.y * -0.5)
		]
	
func rotate_area() -> void:
	$Area.rotation = deg_to_rad(45)
	$CollisionShape2D.rotation = deg_to_rad(45)

func resize_outline(size:Vector2) -> void:
	$Outline.points = [
		Vector2(size.x * -0.5,size.y * -0.5),
		Vector2(size.x *  0.5,size.y * -0.5),
		Vector2(size.x *  0.5,size.y *  0.5),
		Vector2(size.x * -0.5,size.y *  0.5),
		Vector2(size.x * -0.5,size.y * -0.5)
	]

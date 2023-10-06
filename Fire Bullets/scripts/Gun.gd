@tool
extends Node2D
class_name Gun
## A node used to shoot [Bullet]
##
## This node can be used to shoot a [Bullet], you can set the number of bullets to spawn, cooldown, angle variance for acccuracy, and firing arc like those in shotguns.[br]Includes debug options

@export_category("Gun")

## the scene to spawn as a bullet, must be a bullet node ( see [Bullet])
@export var bullet : PackedScene

## Number Of Bullets to spawn at once, setting the value greater than 1 will enable [member Firing_Arc]
@export_range(1,999) var NBS : int = 1

## Cooldown, in seconds, before firing again
@export var CoolDown : float = 0.1

## Used to set the aim accuracy from inaccurate(180) or very accurate(0)
@export_range(0,180) var Angle_Variance : int = 0

## Used to evenly space the bullets[br][b]Note:[/b] Only works if the [member NBS] value is greater than 1
@export_range(1,180) var Firing_Arc : int = 1

## Spawn Point determines where would the bullet be spawned relative to the gun position
@export var Spawn_Point : Vector2

## Timer for cooldown( best to not change the value or tinker with it )
var timer : Timer

## The node for the spawn point( best to not change the value or tinker with it )
var spawn_point_node : Marker2D

@export_group("Debug")

@export_subgroup("Firing Arc")
## The debug type for [member Firing_Arc]. [br]Draws a cone to help you visualize the arc on where the bullets will be spawned.[br][i]only works when [member NBR] is set to a value greater than 1[/i]
@export_enum("None","Editor_Only", "Game_Only", "Game_And_Editor") var Firing_Arc_Debug_Type = "None"
## The cone line width
@export_range(1,5,0.1) var firing_arc_line_width = 1.5
## The cone line color
@export var firing_arc_line_color : Color = Color.WHITE

#@export_subgroup("Shooting Line")
### This will help you visualize on where the bullet's trajectory or where it will travel.
#@export var Shooting_Line_Debug : bool = false
### The shooting line width
#@export_range(1,5,0.1) var shooting_line_width = 1.5
### The shooting line color
#@export var  shooting_line_color : Color = Color.MEDIUM_PURPLE

@export_subgroup("Spawn Point")
## This will help you visualize on where the bullet will spawn when the gun is fired.
@export_enum("None","Editor_Only", "Game_Only", "Game_And_Editor") var Spawn_Point_Debug = "None"
## The radius of the spawn_point
@export_range(1,5,0.1) var spawn_point_line_width = 1
## The spawn point color
@export var spawn_point_color : Color = Color.LIGHT_BLUE



# NBS
func set_nbs(value : int):
	NBS = value
func get_nbs() -> int:
	return NBS

# Cooldown
func set_cooldown(value : float):
	CoolDown = value
	timer.wait_time = value
func get_cooldown() -> float:
	return CoolDown

# Angle Variance
func set_angle_variance(value : int):
	Angle_Variance = value
func get_angle_variance() -> int:
	return Angle_Variance

# firing arc
func set_firing_arc(value : int):
	Firing_Arc = value
func get_firing_arc() -> int:
	return Firing_Arc



func can_shoot():
	return timer.is_stopped()

## Shoots the Bullet ( see [member Gun.Bullet] )[br]speed is the speed of the bullet in pixels per second[br]angle is the angle in which the bullet will be fired at, in degrees. [i/If set to -1, the guns rotations_degrees will be the bullets angle[/i]
func shoot(speed:float=200,angle:float=0.0):
	assert(bullet != null and bullet.get_class() != "Bullet", "Put a bullet scene first and it must be a BULLET Node")
	if can_shoot():
		if NBS == 1:
			var new_bullet = bullet.instantiate()
			new_bullet.global_position = spawn_point_node.global_position
			new_bullet.top_level = true
			new_bullet.speed = speed
			if angle != -1:
				new_bullet.angle = angle + randi_range(-Angle_Variance,Angle_Variance)
			else:
				new_bullet.angle = rotation_degrees + randi_range(-Angle_Variance,Angle_Variance)
			add_child(new_bullet)
		elif NBS >= 2:
			var angleIncrement = Firing_Arc / (NBS - 1)
			var startAngle
			if angle != -1:
				startAngle = angle-(Firing_Arc / 2)
			else:
				startAngle = rotation_degrees-(Firing_Arc / 2)
			for b in NBS:
				var new_bullet = bullet.instantiate()
				new_bullet.global_position = spawn_point_node.global_position# + global_position)
				new_bullet.top_level = true
				new_bullet.speed = speed
				new_bullet.angle = (startAngle + (angleIncrement * b)) + randi_range(-Angle_Variance,Angle_Variance)
				add_child(new_bullet)
		timer.start()
			

func _ready():
	if !Engine.is_editor_hint():
		var cd_timer = Timer.new()
		cd_timer.wait_time = CoolDown
		cd_timer.one_shot = true
		timer = cd_timer
		add_child(cd_timer)
		
		var sp= Marker2D.new()
		sp.position = Spawn_Point
		spawn_point_node = sp
		add_child(sp)
		pass

func _process(delta):
	if !Engine.is_editor_hint():
		pass
	else:
		pass
	queue_redraw()

func _draw():
	if Firing_Arc_Debug_Type == "None":
		pass
	elif Firing_Arc_Debug_Type == "Editor_Only":
		if Engine.is_editor_hint():
			var angle = Firing_Arc  # Adjust this value as needed
			var radius = 100
			var baseCenter = Spawn_Point
			var topPoint = Vector2(radius * cos(deg_to_rad(-angle / 2)), radius * sin(deg_to_rad(-angle / 2))) + Spawn_Point
			draw_line(baseCenter, topPoint, firing_arc_line_color,firing_arc_line_width)
			var bottomPoint = Vector2(radius * cos(deg_to_rad(angle / 2)), radius * sin(deg_to_rad(angle / 2)))+ Spawn_Point
			draw_line(baseCenter, bottomPoint, firing_arc_line_color,firing_arc_line_width)
	elif Firing_Arc_Debug_Type == "Game_Only":
		if !Engine.is_editor_hint():
			var angle = Firing_Arc  # Adjust this value as needed
			var radius = 100
			var baseCenter = Spawn_Point
			var topPoint = Vector2(radius * cos(deg_to_rad(-angle / 2)), radius * sin(deg_to_rad(-angle / 2))) + Spawn_Point
			draw_line(baseCenter, topPoint, firing_arc_line_color,firing_arc_line_width)
			var bottomPoint = Vector2(radius * cos(deg_to_rad(angle / 2)), radius * sin(deg_to_rad(angle / 2))) + Spawn_Point
			draw_line(baseCenter, bottomPoint, firing_arc_line_color,firing_arc_line_width)
	elif Firing_Arc_Debug_Type == "Game_And_Editor":
		if !Engine.is_editor_hint():
			var angle = Firing_Arc  # Adjust this value as needed
			var radius = 100
			var baseCenter = Spawn_Point
			var topPoint = Vector2(radius * cos(deg_to_rad(-angle / 2)), radius * sin(deg_to_rad(-angle / 2))) + Spawn_Point
			draw_line(baseCenter, topPoint, firing_arc_line_color,firing_arc_line_width)
			var bottomPoint = Vector2(radius * cos(deg_to_rad(angle / 2)), radius * sin(deg_to_rad(angle / 2)))+ Spawn_Point
			draw_line(baseCenter, bottomPoint, firing_arc_line_color,firing_arc_line_width)
		else:
			var angle = Firing_Arc
			var radius = 100
			var baseCenter = Spawn_Point
			var topPoint = Vector2(radius * cos(deg_to_rad(-angle / 2)), radius * sin(deg_to_rad(-angle / 2))) + Spawn_Point
			draw_line(baseCenter, topPoint, firing_arc_line_color,firing_arc_line_width)
			var bottomPoint = Vector2(radius * cos(deg_to_rad(angle / 2)), radius * sin(deg_to_rad(angle / 2))) + Spawn_Point
			draw_line(baseCenter, bottomPoint, firing_arc_line_color,firing_arc_line_width)
	if Spawn_Point_Debug == "None":
		pass
	elif Spawn_Point_Debug == "Editor_Only":
		if Engine.is_editor_hint():
			draw_line(Vector2(Spawn_Point.x-15,Spawn_Point.y),Vector2(Spawn_Point.x+15,Spawn_Point.y),spawn_point_color,spawn_point_line_width)
			draw_line(Vector2(Spawn_Point.x,Spawn_Point.y-15),Vector2(Spawn_Point.x,Spawn_Point.y+15),spawn_point_color,spawn_point_line_width)
	elif Spawn_Point_Debug == "Game_Only":
		if !Engine.is_editor_hint():
			draw_line(Vector2(Spawn_Point.x-15,Spawn_Point.y),Vector2(Spawn_Point.x+15,Spawn_Point.y),spawn_point_color,spawn_point_line_width)
			draw_line(Vector2(Spawn_Point.x,Spawn_Point.y-15),Vector2(Spawn_Point.x,Spawn_Point.y+15),spawn_point_color,spawn_point_line_width)
	elif Spawn_Point_Debug == "Game_And_Editor":
		if !Engine.is_editor_hint():
			draw_line(Vector2(Spawn_Point.x-15,Spawn_Point.y),Vector2(Spawn_Point.x+15,Spawn_Point.y),spawn_point_color,spawn_point_line_width)
			draw_line(Vector2(Spawn_Point.x,Spawn_Point.y-15),Vector2(Spawn_Point.x,Spawn_Point.y+15),spawn_point_color,spawn_point_line_width)
		else:
			draw_line(Vector2(Spawn_Point.x-15,Spawn_Point.y),Vector2(Spawn_Point.x+15,Spawn_Point.y),spawn_point_color,spawn_point_line_width)
			draw_line(Vector2(Spawn_Point.x,Spawn_Point.y-15),Vector2(Spawn_Point.x,Spawn_Point.y+15),spawn_point_color,spawn_point_line_width)
#	if Shooting_Line_Debug == true and !Engine.is_editor_hint():
#		draw_line(Spawn_Point,get_local_mouse_position(),shooting_line_color,shooting_line_width)








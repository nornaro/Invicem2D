extends CharacterBody2D

@export var speed: float = 500.0
@export var max_health: float = 100.0
@export var weapon_cooldowns: Array[float] = [0.3, 0.1, 1.0]

@onready var health: float = max_health

var selected_weapon: int = 0
var time_to_shoot: float = 0.0


func shoot(direction: Vector2) -> void:
	var shooter = $Weapons.get_child(selected_weapon)
	shooter.rotation = Vector2(1, 0).angle_to(direction)
	shooter.fire_pattern()


func select_next_weapon() -> void:
	selected_weapon = (selected_weapon + 1)%$Weapons.get_child_count()


func select_prev_weapon() -> void:
	selected_weapon = (selected_weapon - 1)%$Weapons.get_child_count()


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and time_to_shoot <= 0.0:
		shoot(get_global_mouse_position() - global_position)
		time_to_shoot = weapon_cooldowns[selected_weapon]
	time_to_shoot -= delta
	
	if Input.is_action_just_pressed("weapon_next"):
		select_next_weapon()
	if Input.is_action_just_pressed("weapon_prev"):
		select_prev_weapon()
	var direction: Vector2 = Vector2(
		int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")),
		int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	)
	
	velocity = speed*direction
	move_and_slide()
	update_visuals(direction)


func update_visuals(move_dir: Vector2) -> void:
	$AnimatedSprite2D.flip_h = move_dir.x < 0
	if move_dir.length() > 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")


func damage(dmg: float) -> void:
	health -= dmg

extends Node2D

@export var Data: Dictionary = {}
var regen: float = 0.0
var linear_velocity: Vector2
var dead: bool = false

@onready var Sprite: AnimatedSprite2D = $Sprite
@onready var hpBar: Node = $hpBar
@onready var shBar: Node = $shBar
@onready var sh: Node = $Shield
@onready var h0: Node = $Shield/s0
@onready var h2: Node = $Shield/Hit2
@onready var depleted: Node = $Shield/Depleted
@onready var area: Node = $MinionArea
@onready var shield_component: ShieldComponent = ShieldComponent.new()
@onready var damage_component: DamageComponent = DamageComponent.new()

func _ready() -> void:
	if !area.has_meta("owner"):
		add_to_group("minions")
		initialize_data.call()
		initialize_sprite.call()
		shield_component.initialize.call(Data.max_sh, shBar, h2, depleted, sh)
	extra.call()
	linear_velocity = Vector2(-Data.Speed / 5, 0).clamp(Vector2(-1, 0), Vector2(-Data.Speed / 5, 0))

@export var extra: Callable = func() -> void:
	pass

@export var initialize_data: Callable = func() -> void:
	Data["name"] = name
	Data.HP = ceil(Data.HP * 100 * (1 + Data.Size / 10))
	Data["max_hp"] = Data.HP
	hpBar.max_value = Data.max_hp
	Data.Shield = int(Data.Shield * Data.max_hp / 2)
	Data["max_sh"] = Data.Shield
	shBar.max_value = Data.max_sh
	Data.Defense = ceil(Data.Defense * (1 + Data.Size / 10))
	Data.Speed = Data.Speed + 5 - floor(Data.Size / 4) - floor(Data.Size / 4)

@export var initialize_sprite: Callable = func() -> void:
	var global: Dictionary = Global.Data.Minions
	var type: String = Data.Minion[0]
	var minion: String = Data.Minion[1]
	var sprite: String = global[type][minion].keys().pick_random()
	Sprite.speed_scale = 1 + Data.Speed
	Sprite.sprite_frames = global[type][minion][sprite]
	scale *= 10 * Data.Size
	adjust_ui_positions.call()
	Sprite.play("Walking")

@export var adjust_ui_positions: Callable = func() -> void:
	hpBar.position.y -= Data.Size / 10
	shBar.position.y -= Data.Size / 10

func _physics_process(delta: float) -> void:
	if get_tree().get_node_count_in_group("true"):
		return
	apply_physics.call(delta)
		
@export var apply_physics: Callable = func(delta: float) -> void:
	position += linear_velocity * 60 / Engine.physics_ticks_per_second
	z_index = int(position.y)
	correct_rotation.call(delta)
	regeneration.call(delta)

@export var regeneration: Callable = func(delta: float) -> void:
	regen += delta
	if regen >= 1:
		regen -= 1
		Data.HP += Data.max_hp / 100 * Data.Regeneration
		update_hpbar.call()

@export var correct_rotation: Callable = func(delta: float) -> void:
	if rotation != 0:
		rotation = move_toward(rotation, 0, delta)

@export var hurt: Callable = func(data: Dictionary) -> void:
	if dead:
		return
	
	var damage: int = damage_component.calculate_damage.call(data, Data)
	damage = shield_component.take_damage.call(damage)
	
	if damage > 0:
		Data.HP -= damage
		update_hpbar.call()
	
	if Data.HP <= 0:
		die.call()

@export var die: Callable = func() -> void:
	dead = true
	remove_from_group("minions")
	linear_velocity = Vector2.ZERO
	Sprite.connect("animation_looped", queue_free)
	Sprite.play("Dying")
	await get_tree().create_timer(10).timeout
	area.death()
	area.queue_free()

@export var update_hpbar: Callable = func() -> void:
	hpBar.value = Data.HP
	hpBar.modulate = Color(1, pow(Data.HP * 100 / Data.max_hp * 100, 2), pow(Data.HP * 100 / Data.max_hp * 100, 2) / 2, 0.75)

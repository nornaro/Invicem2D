extends Node2D
class_name Minion

@export var Data: Dictionary = {}
var dummyData: Dictionary = {
	"HP": 1,
	"Size": 1,
	"Shield": 0,
	"Defense": 0,
	"Speed": 0.0,
	"Regeneration": 0,
	"Minion": ["Dummy", "Minion"]
}

var regen: float = 0.0
var linear_velocity: Vector2
var death_timer: SceneTreeTimer

@onready var Sprite: AnimatedSprite2D = $Sprite
@onready var hpBar: Node = $hpBar
@onready var shBar: Node = $shBar
@onready var sh: Node = $Shield
@onready var aura: Node = $Shield/Aura
@onready var hit: Node = $Shield/Hit
@onready var depleted: Node = $Shield/Depleted
@onready var area: Node = $MinionArea
@onready var shield_component: ShieldComponent = ShieldComponent.new()
@onready var damage_component: DamageComponent = DamageComponent.new()

var dead: float = 0.0
	
func _ready() -> void:
	area.connect("hurt",hurt)
	if !area.has_meta("owner"):
		add_to_group("minions")
	if !Data.has("HP"):
		Data = dummyData
	init()
	set_death_timer()
	await death_timer.timeout
	Sprite.play("Walking")
	

func init() -> void:
	initialize_data.call()
	initialize_sprite.call()
	shield_component.initialize.call(Data.max_sh, shBar, aura, depleted, sh, hit)
	linear_velocity = Vector2(-Data.Velocity,0)
	extra.call(dummyData)

func set_death_timer() -> void:
	death_timer = get_tree().create_timer(dead)
	
@export var extra: Callable = func(_arguments: Dictionary) -> void:
	get_tree()

@export var initialize_data: Callable = func() -> void:
	Data["name"] = name
	Data.hp = ceil(Data.HP * 100 * (1 + Data.Size / 10))
	Data["max_hp"] = Data.hp
	hpBar.max_value = Data.max_hp
	hpBar.value = hpBar.max_value
	Data.Shield = int(Data.Shield * Data.max_hp / 25) * 4
	Data["max_sh"] = Data.Shield
	shBar.max_value = Data.max_sh
	Data.Defense = ceil(Data.Defense * (1 + Data.Size / 10))
	Data["Velocity"] = sqrt(sqrt(Data.Speed*(1+(16-(Data.Size-1)))))/2

@export var initialize_sprite: Callable = func() -> void:
	if not Global.Data.has("Minions"):
		#Global.Data["Minions"] = {}
		#Data.sprite_name = [Data.get("Minion", ["Dummy"])[0],Data.get("Minion", ["Dummy", "Minion"])[1]]
		var new_frames: SpriteFrames = SpriteFrames.new()
		new_frames.add_animation("Walking")
		new_frames.add_animation("Idle")
		Data["frames"] = {"default": new_frames}

	var sprite_variations: Dictionary = Data.Frames
	
	Sprite.speed_scale *= Data.Velocity
	Sprite.sprite_frames = Data.sprite_name
	scale *= 5+(Data.Size)
	adjust_ui_positions.call()
	Sprite.play("Idle")

@export var adjust_ui_positions: Callable = func() -> void:
	hpBar.position.y -= Data.Size / 10
	shBar.position.y -= Data.Size / 10

func _physics_process(delta: float) -> void:
	#queue_free()
	if dead > 0:
		dead = death_timer.time_left
		return
	if get_tree().get_node_count_in_group("true"):
		return
	if self.apply_physics.is_valid():
		self.apply_physics.call(delta)
		
@export var apply_physics: Callable = func(delta: float) -> void:
	position += linear_velocity * 60 / Engine.physics_ticks_per_second
	z_index = int(position.y)
	correct_rotation.call(delta)
	regeneration.call(delta)

@export var regeneration: Callable = func(delta: float) -> void:
	regen += delta
	if regen >= 1:
		regen -= 1
		Data.hp += Data.max_hp / 100 * Data.Regeneration
		update_hpbar.call()

@export var correct_rotation: Callable = func(delta: float) -> void:
	if rotation != 0:
		rotation = move_toward(rotation, 0, delta)

@export var hurt: Callable = func(data: Dictionary) -> void:
	if dead > 0:
		return

	var damage: int = 0
	damage = damage_component.calculate_damage.call(data, Data)
	damage = shield_component.take_damage.call(damage)
	damage = damage_component.apply_defense.call(damage, data, Data)
	
	if damage <= 0:
		return
		
	Data.hp -= damage
	update_hpbar.call()

	if Data.hp <= 0:
		die.call()

@export var die: Callable = func() -> void:
	dead = 20
	remove_from_group("minions")
	linear_velocity = Vector2.ZERO
	Sprite.connect("animation_looped", queue_free)
	Sprite.play("Dying")
	await get_tree().create_timer(10).timeout
	area.death()
	area.queue_free()

@export var update_hpbar: Callable = func() -> void:
	hpBar.value = Data.hp
	hpBar.modulate = Color(1, pow(Data.hp * 100 / Data.max_hp * 100, 2), pow(Data.hp * 100 / Data.max_hp * 100, 2) / 2, 0.75)

extends Node

@onready var minion:Node = $".."
var Data:Dictionary = {
	"count":5,
}

#func _ready() -> void:
	#minion.hurt = Callable(self, "hurt")  # ✅ Assign custom function

func hurt(data: Dictionary) -> void:
	print("hurt")
	if minion.dead:
		return
	var damage:int = minion.calc_damage(data)
	if !damage:
		return
	
	minion.Data.HP -= damage
	minion.update_hpbar()

	if minion.hpBar.value == 0:
		if Data.count > 0:
			Data.count -= 1
			minion.Data.HP = minion.Data.max_hp
			minion.update_hpbar()
			return

		minion.dead = true
		remove_from_group("minions")
		minion.linear_velocity = Vector2.ZERO
		minion.Sprite.connect("animation_looped", queue_free)
		minion.Sprite.play("Dying")
		await get_tree().create_timer(10).timeout
		minion.area.death()
		minion.area.queue_free()
		return

# Modify minion to call the function dynamically
func _physics_process(delta: float) -> void:
	if minion.has_method("hurt_func"):
		minion.hurt_func.call({})  # Call custom hurt function

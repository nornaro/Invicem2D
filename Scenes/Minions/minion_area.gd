extends Area2D

var network: Node
var in_area: Node
@onready var minion: Node = $".."
signal dead

func _ready() -> void:
	connect("area_entered",_on_area_entered)
	network = get_tree().get_first_node_in_group("Network")
	in_area = get_tree().get_first_node_in_group("In")

func _on_area_entered(area:Area2D) -> void:
	if area.name == "Spawn":
		return
	if area.get_parent().get_parent().name == "Castle":
		area.get_parent().life_stolen()
		remove_from_group("minions")
		dead.emit(self)	
		get_parent().queue_free()
	if area.name == "Out":
		minion.Data["id"] = multiplayer.get_unique_id()
		minion.Data["gposy"] = minion.global_position.y
		if Global.mp:
			network.process_data(minion.Data)
			return
		minion.global_position.x = in_area.global_position.x
		minion.get_node("MinionArea").set_meta("owner",minion.Data["id"])
		minion.set_meta("owner",minion.Data["id"])	
		print(area," ",area.get_parent().get_groups())
	if area.is_in_group("projectile"):
		get_parent().hurt(area.get_parent().Data)
		area.get_parent().hit()
		
		
func death() -> void:
	dead.emit(self)

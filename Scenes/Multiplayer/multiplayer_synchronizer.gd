extends MultiplayerSynchronizer


## 2DO: build actions send to server

@export var score = {}
@export var turn = {}
@export var turn_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score[multiplayer.get_unique_id()] = 0
	turn[multiplayer.get_unique_id()] = false
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)


@rpc("call_local")
func increase_score(id: int):
	if !score.has(id):
		score[id] = 0
	score[id] += 1

@rpc("call_local")
func end_turn(id: int, toggled_on: bool):
	turn[id] = toggled_on
	if turn.values().has(false):
		return
	for key in turn.keys():
		turn[key] = false
	turn_count += 1
	

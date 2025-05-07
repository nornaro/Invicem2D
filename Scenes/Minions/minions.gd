extends Node

var loading_resources : Dictionary = {}
var minions : Dictionary = {}
var counter:int = 0
var base_path:String = "res://Scenes/Minions/"
var timeA:int
var loading:Node
var progress:int = 0
# Custom signal to notify when all resources are loaded
signal resources_loaded
signal done

func _ready() -> void:
	if get_tree().get_first_node_in_group("ProgressBar"):
		get_tree().get_first_node_in_group("ProgressBar").show()
	loading = get_tree().get_first_node_in_group("Loading")
	timeA = Time.get_ticks_msec()
	load_minions()  # Make sure to call load_minions when the node is ready

func load_minions() -> void:
	var types:Array = Global.RL.get_directories_at(base_path)
	
	for type:String in types:
		#progress += minions[type].keys().size()
		minions[type] = {}
		for minion:String in Global.RL.get_directories_at(base_path + type):
			counter += 1
			var minion_parts:Array = minion.split("_")  # Only split once
			if not minions[type].has(minion_parts[0]):
				minions[type][minion_parts[0]] = {}

			var path:String = base_path + type + "/" + minion + ".tres"
			# Start loading resource in a separate thread
			loading_resources[path] = ResourceLoader.load_threaded_request(path, "SpriteFrames")
	
	# Wait for all resources to load asynchronously (via custom signal)
	await resources_loaded
	Global.Data["Minions"] = minions
	var timeB:int = Time.get_ticks_msec()
	print_debug("Minion loading took: ", (timeB-timeA)/1000.0,"ms")
	emit_signal("done")
	if get_tree().get_first_node_in_group("ProgressBar"):
		get_tree().get_first_node_in_group("ProgressBar").hide()
	set_script("")

func _physics_process(_delta: float) -> void:
	for path:String in loading_resources.keys():
		var status:ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(path)
		if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			var resource:Resource = ResourceLoader.load_threaded_get(path)
			var sub_path:String = path.split(base_path)[1]
			var path_parts:Array = sub_path.split("/")
			var type:String = path_parts[0]
			var minion_parts:Array = path_parts[1].split(".")[0].split("_")
			print_debug(path_parts)
			minions[type][minion_parts[0]][minion_parts[1]] = resource
			loading_resources.erase(path)
			if loading:
				loading.progress(1-loading_resources.keys().size()/float(counter))
	if loading_resources.is_empty():
		emit_signal("resources_loaded")
		#set_process_mode(PROCESS_MODE_DISABLED)

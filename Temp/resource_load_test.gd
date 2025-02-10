extends Node

var loading_resources : Dictionary = {}
var minions : Dictionary = {}
var counter = 0
var base_path = "res://Scenes/Minions/"
var timeA

# Custom signal to notify when all resources are loaded
signal resources_loaded

func _ready():
	timeA = Time.get_ticks_msec()
	load_minions()  # Make sure to call load_minions when the node is ready
	connect("resources_loaded", loading_done)

func load_minions():
	var types = Global.RL.get_directories_at(base_path)
	
	for type in types:
		minions[type] = {}
		for minion in Global.RL.get_directories_at(base_path + type):
			counter += 1
			var minion_parts = minion.split("_")  # Only split once
			if not minions[type].has(minion_parts[0]):
				minions[type][minion_parts[0]] = {}

			var path = base_path + type + "/" + minion + ".tres"
			# Start loading resource in a separate thread
			loading_resources[path] = ResourceLoader.load_threaded_request(path, "SpriteFrames")
	
	# Wait for all resources to load asynchronously (via custom signal)
	await resources_loaded

func loading_done():
	var timeB = Time.get_ticks_msec()
	print("Took: ", timeB-timeA)

func _process(delta):
	var all_loaded = true
	# Check the status of loading
	for path:String in loading_resources.keys():
		var status = ResourceLoader.load_threaded_get_status(path)
		if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			var resource = ResourceLoader.load_threaded_get(path)
			var sub_path = path.split(base_path)[1]
			var path_parts = sub_path.split("/")
			var type = path_parts[0]
			var minion_parts = path_parts[1].split(".")[0].split("_")
			
			minions[type][minion_parts[0]][minion_parts[1]] = resource
			loading_resources.erase(path)  # Resource is done loading
	
		# Emit signal when all resources are loaded
		if loading_resources.is_empty():
			emit_signal("resources_loaded")

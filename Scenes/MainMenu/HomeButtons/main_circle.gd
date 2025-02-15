@tool
extends GridContainer

@onready var home_btton:GDScript = preload("home_button.gd")
var button_count:int = 0
#var sc

func _ready() -> void:
	var node:Node = get_node_or_null("../../Marker2D")
	if !node:
		return
	position = node.position
	size = Vector2(get_viewport().get_visible_rect().size.x/5,get_viewport().get_visible_rect().size.y/4)
	position -= size/2
		
#func load_sc(data) -> void:
	#var script_base_dir = get_script().resource_path.get_base_dir() + "/" + data[0] + "_" + data[1] + "/"
	#if Global.RL.file_exists(script_base_dir+"script.gd"):
		#sc = Global.RL.load(script_base_dir+"script.gd")
		#sc._ready()
		
func load_buttons(data: Array) -> void:
	# Construct the relative path
	var path:String = data[0] + "_" + data[1] + "/"
	var script_base_dir:String = get_script().resource_path.get_base_dir() + "/"
	var global_path:String = script_base_dir + path
		
	# Open the directory
	var base_dir:Array = Global.RL.get_directories_at(global_path)

	for button:String in base_dir:
		var styles:String = ""
		if Global.RL.dir_exists(global_path+button+"/Styles"):
			styles = "Styles/" + Global.style + "/"
			
			# Create a TextureButton instance
		var instance:TextureButton = TextureButton.new()
		var buttontextures:Array = Global.RL.get_files_at(global_path + button + "/" + styles)
		for texture:String in ["normal","pressed","hover","disabled","focused","click_mask"]:
			var texture_path:String = global_path + button + "/" + styles + pick_random_texture(buttontextures, texture)
			if Global.RL.file_exists(texture_path):
				instance.set("texture_" + texture, Global.RL.load(texture_path) as Texture2D)
		instance.name = button
		instance.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		instance.size_flags_vertical = Control.SIZE_EXPAND_FILL
		instance.ignore_texture_size = true
		instance.stretch_mode = TextureButton.STRETCH_SCALE
		var script_path:String = global_path + button + "/script.gd"
		if Global.RL.file_exists(script_path):
			instance.set_script(Global.RL.load(script_path))
		button_count += 1
		add_child(instance)
		if button_count <= 2:
			columns = 1
			continue
		if button_count > columns * columns:
			columns += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if Engine.is_editor_hint():
		#position = $"../Marker2D".position


func pick_random_texture(buttontextures: Array, type: String) -> String:
	var filtered:Array = buttontextures.filter(func(item:String) -> bool:
		return item.begins_with(type) and item.ends_with(".png")
	)
	if filtered.size() > 0:
		return filtered[randi() % filtered.size()]
	return ""

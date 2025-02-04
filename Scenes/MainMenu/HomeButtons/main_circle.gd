@tool
extends GridContainer

@onready var home_btton = preload("home_button.gd")
var button_count = 0
var sc

func _ready() -> void:
	position = $"../../Marker2D".position
	size = Vector2(get_viewport().get_visible_rect().size.x/5,get_viewport().get_visible_rect().size.y/4)
	position -= size/2
		
#func load_sc(data) -> void:
	#var script_base_dir = get_script().resource_path.get_base_dir() + "/" + data[0] + "_" + data[1] + "/"
	#if FileAccess.file_exists(script_base_dir+"script.gd"):
		#sc = load(script_base_dir+"script.gd")
		#sc._ready()
		
func load_buttons(data: Array):
	# Construct the relative path
	var path = data[0] + "_" + data[1] + "/"
	var script_base_dir = get_script().resource_path.get_base_dir() + "/"
	var global_path = script_base_dir + path
		
	# Open the directory
	var base_dir = DirAccess.open(global_path)
	if not base_dir:
		push_error("Error: Directory not found:", global_path)
		return

	for button in base_dir.get_directories():
		var styles = ""
		if base_dir.dir_exists(button+"/Styles"):
			styles = "Styles/" + Global.style + "/"
			
			# Create a TextureButton instance
		var instance = TextureButton.new()
		var buttontextures = DirAccess.get_files_at(global_path + button + "/" + styles)
		for texture in ["normal","pressed","hover","disabled","focused","click_mask"]:
			var texture_path = global_path + button + "/" + styles + pick_random_texture(buttontextures, texture)
			if FileAccess.file_exists(texture_path):
				instance.set("texture_" + texture, load(texture_path) as Texture2D)
		instance.name = button
		instance.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		instance.size_flags_vertical = Control.SIZE_EXPAND_FILL
		instance.ignore_texture_size = true
		instance.stretch_mode = TextureButton.STRETCH_SCALE
		var script_path = global_path + button + "/script.gd"
		if FileAccess.file_exists(script_path):
			instance.set_script(load(script_path))
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
	var filtered = buttontextures.filter(func(item):
		return item.begins_with(type) and item.ends_with(".png")
	)
	if filtered.size() > 0:
		return filtered[randi() % filtered.size()]
	return ""

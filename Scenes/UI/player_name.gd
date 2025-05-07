extends RichTextLabel

@onready var pn: Node = $"."
@onready var en: Node = $"../EditName"
@onready var ne: Node = $"../EditName/NameEdit"
@onready var cr: Node = $"../EditName/ColorRect"
@onready var u: Node = $"../EditName/U"
@onready var b: Node = $"../EditName/B"

func _ready() -> void:
	connect("gui_input",_change_name_clicked)
	ne.connect("text_changed",_change_name)
	cr.connect("color_changed",_change_name_color)
	b.connect("toggled",_change_name_b)
	u.connect("toggled",_change_name_u)
	var user_name := OS.get_environment("USERNAME") # Windows
	if user_name.is_empty():
		user_name = OS.get_environment("USER") # Linux/macOS
	text = user_name
	ne.text = text
	
func _change_name_clicked(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("RMB"):
		show_change_name()
	
func show_change_name() -> void:
	pn.hide()
	en.show()
	ne.grab_focus()
			
func _change_name() -> void:
	text = ne.text
	get_tree().get_first_node_in_group("Network").set_player_name(text, Global.id)
	Global.clients[multiplayer.get_unique_id()].name = text
	get_tree().call_group("Update","update")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_text_newline"):
		en.hide()
		pn.show()
	Global.clients[multiplayer.get_unique_id()].name = text
	get_tree().call_group("Update","update")

func _change_name_color(color: Color) -> void:
	var text_parts: Array = ne.text.replace("]","|||").replace("[","|||").split("|||")
	var colortext: String
	for part: String in text_parts:
		if part.contains("color="):
			colortext = part
	if colortext:
		text = text.replace(colortext,"color=#" + str(color.to_html(false)))
		ne.text = text
		return
	text = "[color=#" + str(color.to_html(false)) + "]" + text + "[/color]"
	ne.text = text
	
func _change_name_u(toggle: bool) -> void:
	if text.contains("[u]"):
		if toggle:
			return
		text = text.replace("[u]","").replace("[/u]","")
		update()
	if !toggle:
		return
	text = "[u]" + text + "[/u]"
	update()
		
		
func _change_name_b(toggle: bool) -> void:
	if text.contains("[b]"):
		if toggle:
			return
		text = text.replace("[b]","").replace("[/b]","")
	if !toggle:
		return
	text = "[b]" + text + "[/b]"
	ne.text = text

func update() -> void:
	ne.text = text

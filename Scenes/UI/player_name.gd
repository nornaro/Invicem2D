extends RichTextLabel

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
	
func _change_name_clicked(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("RMB"):
		en.show()
		ne.grab_focus()
			
func _change_name() -> void:
	text = ne.text
	get_tree().get_first_node_in_group("Network").set_player_name(text, Global.id)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_text_newline"):
		en.hide()

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
		ne.text = text
	if !toggle:
		return
	text = "[u]" + text + "[/u]"
	ne.text = text
		
		
func _change_name_b(toggle: bool) -> void:
	if text.contains("[b]"):
		if toggle:
			return
		text = text.replace("[b]","").replace("[/b]","")
		ne.text = text
	if !toggle:
		return
	text = "[b]" + text + "[/b]"
	ne.text = text

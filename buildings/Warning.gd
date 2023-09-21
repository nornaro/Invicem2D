extends RichTextLabel

var timeout = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	bbcode_enabled = true

"""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if text && timeout == 1:
		text = "[center][color=red][b][size=20]"+text+"[/size][/b][/color][/center]"
		return		
	if timeout <= 0:
		timeout = 1
		text = ""
		return
	if timeout < delta:
		timeout -= delta
		return
		
		2DO better timeout
		"""

extends Panel

@onready var choice = null
@onready var confirm = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		if Input.is_key_pressed(KEY_ENTER):
			_on_confirm_pressed()
		if Input.is_key_pressed(KEY_ESCAPE):
			_on_cancel_pressed()
			
func _on_cancel_pressed():
	choice = null
	$".".hide()
	pass # Replace with function body.

func _on_confirm_pressed():
	confirm = choice
	choice = null
	$".".hide()
	pass # Replace with function body.

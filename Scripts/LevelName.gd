extends CanvasLayer


export (String) var level_name = "Level 0: Placeholder text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$RichTextLabel.bbcode_text = $RichTextLabel.bbcode_text.replacen("$Text", level_name)
	$Appear.interpolate_property($RichTextLabel, "modulate:a8", 0, 255, 1.25)
	$Appear.start()

func _start_disappearing():
	$Disappear.interpolate_property($RichTextLabel, "modulate:a8", 255, 0, 2.5)
	$Disappear.start()

func _hide_label():
	self.queue_free()

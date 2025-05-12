extends CanvasLayer


var selectedText: Array = []
var inProgress: bool = false
var textStage: int = -1;
@onready var background = $background
@onready var textLabel = $background/textLabel
@onready var nameFrame = $Name
@onready var nameText = $Name/textLabel

func _ready():
	background.visible = false
	nameFrame.visible = false;
	SignalBus.connect("displayDialog", Callable(self, "on_displayDialog"));

func showText():
	textStage += 1;
	if textStage != len(selectedText):
		textLabel.text = selectedText[textStage];

func nextLine():
	if textStage != len(selectedText) - 1:
		showText()
	else:
		textStage = -1;
		finish()

func finish():
	textLabel.text = ""
	background.visible = false
	nameFrame.visible = false;
	inProgress = false
	get_tree().paused = false
	
func on_displayDialog(text : Array, NPCName: String):
	if NPCName != null:
		nameFrame.visible = true;
		nameText.text = NPCName
	if inProgress:
		nextLine()
	else:
		get_tree().paused = true
		background.visible = true
		inProgress = true
		selectedText = text;
		showText()

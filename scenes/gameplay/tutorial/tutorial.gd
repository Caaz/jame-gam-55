extends Control

@export var player:Player
@onready var flapped_checkbox:CheckBox = find_child("Flapped")
@onready var pitched_checkbox:CheckBox = find_child("Pitched")
@onready var rolled_checkbox:CheckBox = find_child("Rolled")
@export var ui:Control
var tween:Tween
var pitched:bool = false:
	set(new):
		pitched = new
		pitched_checkbox.button_pressed = pitched
		_check_status()
var rolled:bool = false:
	set(new):
		rolled = new
		rolled_checkbox.button_pressed = rolled
		_check_status()
var flapped:bool = false:
	set(new):
		flapped = new
		flapped_checkbox.button_pressed = flapped
		_check_status()


func _ready() -> void:
	player.pitched.connect(func():
		pitched = true
	)
	player.rolled.connect(func():
		rolled = true
	)
	player.flapped.connect(func():
		flapped = true
	)

func _check_status() -> void:
	if tween:
		return
	if pitched and rolled and flapped:
		tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CIRC)
		tween.tween_property(self, "modulate", Color.WHITE, .3)
		await tween.finished
		tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CIRC)
		tween.tween_property(ui, "modulate", Color.WHITE, .3)
		await tween.finished
		queue_free()
